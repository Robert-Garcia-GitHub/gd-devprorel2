import { LightningElement, api, track } from "lwc";
import communityId from "@salesforce/community/Id";
import getOrderHistory from "@salesforce/apex/GDIB2B_OrderHistoryService.getOrderHistory";

import getUserId from "@salesforce/apex/gdicoe_displayUserHelper.getUserId";
import getUserName from "@salesforce/apex/gdicoe_displayUserHelper.getUserName";
import getUserEmail from "@salesforce/apex/gdicoe_displayUserHelper.getUserEmail";
import getName from "@salesforce/apex/gdicoe_displayUserHelper.getName";
import getAccountId from "@salesforce/apex/gdicoe_displayUserHelper.getAccountId";
import getAccountExternalId from "@salesforce/apex/gdicoe_displayUserHelper.getAccountExternalId";

export default class Userinfoexample extends LightningElement {
  @track displayUserId = "";
  @track displayUserUsername = "";
  @track displayUserEmail = "";
  @track displayUserName = "";
  @track displayUserAccountId
  @track displayUserAccountExternalId = "";
  @track displayUserError = "none";
  @track displayUserHasOrderHistory = "unknown";

  @api userDataVisible;

  fromDate = "";
  toDate = "";

  connectedCallback() {
    this.getUserDetails().then(result => {});
    this.checkIfOrders().then(result => {});
  }

  async getUserDetails() {
    this.displayUserId = await getUserId();
    this.displayUserName = await getName();
    this.displayUserUsername = await getUserName();
    this.displayUserEmail = await getUserEmail();
    this.displayUserAccountExternalId = await getAccountExternalId();
  }

  async checkIfOrders() {
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

    this.toDate = String(year) + month + day;
    this.fromDate = String(today.getFullYear() - 20) + month + day;

    try {
      this.isLoading = true;
      let allOrders = await getOrderHistory({
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

      if (
        !JSON.stringify(allOrders).startsWith("Error") &&
        allOrders != '{"TotalRecords": "0"}' &&
        allOrders.length
      ) {
        this.displayUserHasOrderHistory = "yes";
      } else {
        this.displayUserHasOrderHistory = "no";
      }
      this.isLoading = false;
    } catch (e) {
      console.error(e);
    }
  }
}