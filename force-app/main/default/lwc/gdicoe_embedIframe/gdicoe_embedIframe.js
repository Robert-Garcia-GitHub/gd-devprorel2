import { LightningElement, api, track } from "lwc";

// import items from the helper class to look up user data
import getUserId from "@salesforce/apex/gdicoe_embedIframeHelper.getUserId";
import getUserName from "@salesforce/apex/gdicoe_embedIframeHelper.getUserName";
import getUserEmail from "@salesforce/apex/gdicoe_embedIframeHelper.getUserEmail";
import getName from "@salesforce/apex/gdicoe_embedIframeHelper.getName";
import getAccountExternalId from "@salesforce/apex/gdicoe_embedIframeHelper.getAccountExternalId";

// import items  we need to check the order history
import communityId from "@salesforce/community/Id";
import getOrderHistory from "@salesforce/apex/GDIB2B_OrderHistoryService.getOrderHistory";

export default class gdicoe_embedIframe extends LightningElement {
  // properties that come from the Experience builder
  @api srcAttribute;
  @api widthAttribute;
  @api heightAttribute;
  @api divAlignment;
  @api appendQueryString;
  @api orderCheck;
  @api yearRange;
  @api specificMonth;

  // properties to get user info for query string
  qsError = "no";

  qsId = "";
  qsName = "";
  qsUserName = "";
  qsEmail = "";
  qsAccount = "";

  qsOrdered = "no";

  // property to indicate iframe is ready to be displayed
  @track iframeReady = false;

  // properties used to set iframe alignment and source url
  _divStyle = "";
  _iframeSrc = "";

  // properties used in order check
  _fromDate = "";
  _toDate = "";

  connectedCallback() {
    // let's resolve the user information promises so all that data is ready before we display the iframe
    this.getQsId().then((result) => {});
    this.getQsName().then((result) => {});
    this.getQsUserName().then((result) => {});
    this.getQsEmail().then((result) => {});
    this.getQsAccount().then((result) => {});

    // okay, now let's check if any desired orders are found, that will complete the iframe display
    this.checkIfOrders().then((result) => {});
  }

  // load up the query string variable with the user's ID
  async getQsId() {
    // get the user id
    this.qsId = await getUserId();
  }

  // load up the query string variable with the user's Name
  async getQsName() {
    // get the user's name
    this.qsName = await getName();
  }

  // load up the query string variable with the user's username
  async getQsUserName() {
    // get the user's username
    this.qsUserName = await getUserName();
  }
  
  // load up the query string variable with the user's email address
  async getQsEmail() {
    // get the user's email address
    this.qsEmail = await getUserEmail();
  }

  // load up the query string variable with the user's account external ID
  async getQsAccount() {
    // get the user's account external ID
    this.qsAccount = await getAccountExternalId();
  }

  // check if the user has any order, based on the component's specified parameters
  async checkIfOrders() {
    // get today's date
    let today = new Date(),
      year = today.getFullYear(),
      day =
        today.getDate() > 9
          ? String(today.getDate())
          : "0" + String(today.getDate()),
      month =
        today.getMonth() + 1 > 9
          ? String(today.getMonth() + 1)
          : "0" + String(today.getMonth() + 1);

    // do requested order check
    if (
      this.orderCheck === "specific-month" &&
      today.getMonth() + 1 !== this.specificMonth
    ) {
      // don't bother checking if we're checking a specific month but we're not in the desired month
      this.qsError = "no";
      this.qsOrdered = "no";
      this.updateComponent();
    } else {
      // set up from- and to-date parameters
      if (this.orderCheck === "year-range") {
        // checking orders in a given year range
        this._fromDate =
          String(today.getFullYear() - this.yearRange) + month + day;

        this._toDate = String(year) + month + day;
      } else {
        // checking orders in a specific month
        this._fromDate = String(year) + month + "01";

        this._toDate = String(year) + month + day;
      }

      // try to get orders for user
      try {
        let allOrders = await getOrderHistory({
          communityId: communityId,
          orderStatus: "ALL",
          startRow: "1",
          maxRows: "1",
          searchFilter: "",
          fromDate: this._fromDate,
          toDate: this._toDate,
          sortOrder: "ORDERDATE",
          sortDir: "DESC"
        });

        // check if returned result has order data
        if (
          !JSON.stringify(allOrders).startsWith("Error") &&
          allOrders !== '{"TotalRecords": "0"}' &&
          allOrders.length
        ) {
          // it does, customer has ordered within year range
          this.qsError = "no";
          this.qsOrdered = "yes";
          this.updateComponent();
        } else {
          // it doesn't, customer has NOT ordered within year range
          this.qsError = "no";
          this.qsOrdered = "no";
          this.updateComponent();
        }
      } catch (e) {
        // something went wrong, indicate an error occured
        this.qsError = "yes";
        this.updateComponent();
      }
    }
  }

  // reverse a string
  reverseString(value) {
    var result = value.split("").reverse().join("");
    return result;
  }

  // generate a random string, given expected length and character set to use
  generateString(length, characters) {
    var result = "";
    for (let i = 0; i < length; i++) {
      result += characters.charAt(
        Math.floor(Math.random() * characters.length)
      );
    }
    return result;
  }

  // conceal string value by obfuscating it as a base64 string
  concealText(value) {
    // character set for random string generation
    const characters =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    // start by converting the value to base64
    var result = btoa(value);

    // make the result url-safe, just in case
    result = result.replace("+", "-").replace("/", "_");

    // check the ending of base64 string
    if (result.endsWith("==")) {
      // if it ends with "==" :
      // - drop the "=="
      // - pad start of string with "2" plus a random char to maintain string length
      result =
        "2" +
        this.generateString(1, characters) +
        result.substring(0, result.length - 2);
    } else if (result.endsWith("=")) {
      // if it ends with "=" :
      // - drop the "="
      // - pad start of string with "1" to maintain string length
      result = "1" + result.substring(0, result.length - 1);
    } else {
      // if no "==" or "=" found :
      // - pad start of string with "0" plus 3 random chars to maintain base64-expected length
      result = "0" + this.generateString(3, characters) + result;
    }

    // pad start of string with 4 random chars, to further obfuscate result
    result = this.generateString(4, characters) + result;

    // reverse the string, to further obfuscate result
    result = this.reverseString(result);

    // return that final result
    return result;
  }

  // reveal orginal string value that was base64-obfuscated
  revealText(value) {
    // undo the string reversal
    var result = this.reverseString(value);

    // drop the 4 random chars padded at the start of the string
    result = result.substring(4);

    // undo the url-safe encoding
    result = result.replace("_", "/").replace("-", "+");

    // check what the resulting string starts with
    if (result.startsWith("2")) {
      // this was originally a base64 string ending in "==", so :
      // - drop the "2" plus the random char at the start of the string
      // - add the "==" to the end
      // - base64 decode the result
      result = atob(result.substring(2) + "==");
    } else if (result.startsWith("1")) {
      // this was originally a base64 string ending in "=", so :
      // - drop the "1" at the start of the string
      // - add the "=" to the end
      // - base64 decode the result
      result = atob(result.substring(1) + "=");
    } else if (result.startsWith("0")) {
      // this was originally a base64 string not ending in "==" or "=", so :
      // - drop the "0" plus the 3 random chars at the start of the string
      // - base64 decode the result
      result = atob(result.substring(4));
    } else {
      // this start of string is unexpected, so we return the original value to indicate an error
      result = value;
    }

    // we're done, return result
    return result;
  }

  // update the component's iframe if we need to
  updateComponent() {
    // get source url for iframe
    let iframeSrc = this.srcAttribute;
    let querystring = "";

    // append query string to soruce url if checkbox set
    if (this.appendQueryString) {
      // work out the query string to send
      querystring =
        "?error=" +
        this.qsError +
        "&id=" +
        this.qsId +
        "&name=" +
        this.qsName +
        "&user=" +
        this.qsUserName +
        "&email=" +
        this.qsEmail +
        "&account=" +
        this.qsAccount +
        "&ordered=" +
        this.qsOrdered;

      // append it to the iframe's url
      iframeSrc = iframeSrc + "?data=" + this.concealText(querystring);
    }

    // set the alignment and source url of the iframe
    this._divStyle = "text-align: " + this.divAlignment;
    this._iframeSrc = iframeSrc;

    // indicate that iframe is ready to be displayed
    this.iframeReady = true;
  }
}