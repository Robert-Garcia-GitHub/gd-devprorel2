import { LightningElement, api, track } from "lwc";

// import items from the helper class to look up user data
import getUserDataDelimited from "@salesforce/apex/gdicoe_embedIframeHelper.getUserDataDelimited";

// import items  we need to check the order history
import communityId from "@salesforce/community/Id";
import getOrderHistory from "@salesforce/apex/GDIB2B_OrderHistoryService.getOrderHistory";

// import static resources
import embedImageSpinner from "@salesforce/resourceUrl/gdicoe_embedIframeSpinner";

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
  @api debugIframeUrl;

  // property to indicate iframe is ready to be displayed
  @track _iframeReady = false;

  // properties that affect the iframe's display
  @track _divStyle = "";
  @track _spinnerUrl = "";
  @track _iframeSrc = "";

  // properties that allow debug information to be displayed
  @track _iframeDebug = false;
  @track _debugData = "";
  @track _debugUrl = "";
  @track _debugQuery = "";
  @track _debugJson = "";

  // properties to get user info for query string
  qsUserData = "";

  // properties used to build query string
  qsError = "no";
  qsOrdered = "no";
  qsUserId = "";
  qsName = "";
  qsUserName = "";
  qsEmail = "";
  qsAccountId = "";
  qsAccountExternalId = "";

  // properties used in order check
  dateToday = new Date();
  fromDate = "";
  toDate = "";
  allOrders = "";

  connectedCallback() {
    // set the div's alignment and spinner image url
    this._divStyle = "text-align: " + this.divAlignment;
    this._iframeDebug = this.debugIframeUrl;
    this._spinnerUrl = embedImageSpinner;

    // let's resolve the user information promises so all that data is ready before we display the iframe
    this.getUserData().then((result) => {});

    // okay, now let's check if any desired orders are found, that will complete the iframe display
    this.checkIfOrders().then((result) => {});
  }

  async getUserData() {
    // get the user's data as a tab-delimited string
    this.qsUserData = await getUserDataDelimited();
  }

  // pad day or month so they have two digits
  padDayOrMonth(value) {
    return value > 9 ? String(value) : "0" + String(value);
  }

  // get a date string in "YYYYMMDD" format given a year, month, and day
  getDateStringFrom(year, month, day) {
    let result =
      String(year) + this.padDayOrMonth(month) + this.padDayOrMonth(day);

    return result;
  }

  // get a date string in "YYYYMMDD" format for a given date
  getDateString(date) {
    return this.getDateStringFrom(
      date.getFullYear(),
      date.getMonth() + 1,
      date.getDate()
    );
  }

  // get a date value from a given date + or - a given value (-1 = yesterday, +1 = tomorrow, etc.)
  getDateOffsetBy(date, value) {
    let temp = new Date();
    temp.setDate(date.getDate() + value);
    return temp;
  }

  // check if the user has any order, based on the component's specified parameters
  async checkIfOrders() {
    // do requested order check

    let year = this.dateToday.getFullYear();
    let month = this.dateToday.getMonth() + 1;
    let day = this.dateToday.getDate();

    // set up reasonable from- and to-date values, based on order check selected
    switch (this.orderCheck) {
      case "year-range":
        // we set up a range that spans years
        this.fromDate = this.getDateStringFrom(
          year - this.yearRange,
          month,
          day
        );
        this.toDate = this.getDateString(this.dateToday);
        break;

      case "specific-month":
        // we set up a range from the beginning of the current month until today
        this.fromDate = this.getDateStringFrom(year, month, 1);
        this.toDate = this.getDateStringFrom(year, month, day);
        break;

      case "yesterday-and-today-in-month":
      case "yesterday-and-today":
        // we set up a range from yesterday to today
        this.fromDate = this.getDateString(
          this.getDateOffsetBy(this.dateToday, -1)
        );
        this.toDate = this.getDateString(this.dateToday);
        break;

      default:
        // default to tomorrows's date as from- and to-dates, the order check may fail, but we can trap it
        // we just need this as a catch-all, in case an unexpected order check is provided by accident
        // (that can happen if someone modifies the TargetConfigs for the component)
        this.fromDate = this.getDateString(
          this.getDateOffsetBy(this.dateToday, +1)
        );
        this.toDate = this.getDateString(
          this.getDateOffsetBy(this.dateToday, +1)
        );
    }

    // try to get orders for user
    try {
      // get the order history for the user, given the from- and to-date range
      this.allOrders = await getOrderHistory({
        communityId: communityId,
        orderStatus: "ALL",
        startRow: "1",
        maxRows: "1",
        searchFilter: "",
        fromDate: this.fromDate,
        toDate: this.toDate,
        sortOrder: "ORDERDATE",
        sortDir: "DESC"
      });

      // examine the order data received
      if (this.allOrders.includes("Read timed out")) {
        // there was a timeout getting the order data
        this.qsError = "yes";
        this.qsOrdered = "read-timed-out";
      } else if (
        !JSON.stringify(this.allOrders).startsWith("Error") &&
        this.allOrders !== '{"TotalRecords": "0"}' &&
        this.allOrders.length
      ) {
        // there was actual order data, so we parse it
        this.allOrders = JSON.parse(this.allOrders);
        // check if we have at least one order in the order data
        if (this.allOrders.length !== 0 && this.allOrders.OrderList) {
          // we do, so we succeeded in finding an order in the given date range
          this.qsError = "no";
          this.qsOrdered = "yes";
        } else {
          // we don't, so there may have been a problem getting the order data
          this.qsError = "yes";
          this.qsOrdered = "order-history-failed";
        }
      } else {
        // the order data wasn't as we expected it to be, so there may have been a problem getting the order data
        this.qsError = "yes";
        this.qsOrdered = "order-history-failed";
      }
    } catch (e) {
      // something went wrong, indicate an unknown error occured
      this.qsError = "yes";
      this.qsOrdered = "unknown";
    }

    // we found data, we just need to check that if matches a month if it was specified
    switch (this.orderCheck) {
      case "yesterday-and-today-in-month":
      case "yesterday-and-today":
        // check if we found an order
        if (this.qsError === "no" && this.qsOrdered === "yes") {
          // check if we're in the right month
          if (this.dateToday.getMonth() + 1 !== this.specificMonth) {
            // we're not, so override the order check and set it to "no"
            this.ordered = "no";
          }
        }
        break;

      default:
        break;
    }

    this.updateComponent();
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
    // get user data in preparation for working out query string
    let dataArray = this.qsUserData.split("\t");
    this.qsUserId = dataArray[0];
    this.qsName = dataArray[1];
    this.qsUserName = dataArray[2];
    this.qsEmail = dataArray[3];
    this.qsAccountId = dataArray[4];
    this.qsAccountExternalId = dataArray[5];

    // get source url for iframe
    let iframeSrc = this.srcAttribute;

    // append query string to source url if checkbox set
    let querystring = "";
    if (this.appendQueryString) {
      // work out the query string to send
      querystring =
        "?error=" +
        this.qsError +
        "&id=" +
        this.qsUserId +
        "&name=" +
        this.qsName +
        "&user=" +
        this.qsUserName +
        "&email=" +
        this.qsEmail +
        "&account=" +
        this.qsAccountExternalId +
        "&ordered=" +
        this.qsOrdered +
        "&community=" +
        communityId +
        "&today=" +
        this.getDateString(this.dateToday) +
        "&from=" +
        this.fromDate +
        "&to=" +
        this.toDate +
        "&check=" +
        this.orderCheck;

      // append it to the iframe's url
      iframeSrc = iframeSrc + "?data=" + this.concealText(querystring);
    }

    // set the source url of the iframe
    this._iframeSrc = iframeSrc;

    // indicate that iframe is ready to be displayed
    this._debugData = "[ " + this.qsUserData.replaceAll("\t", " | ") + " ]";
    this._debugUrl = this.srcAttribute;
    this._debugQuery = this.revealText(querystring);
    this._debugJson = this.allOrders;
    this._iframeReady = true;
  }
}