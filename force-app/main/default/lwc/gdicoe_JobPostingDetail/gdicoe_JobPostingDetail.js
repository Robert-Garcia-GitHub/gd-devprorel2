import { LightningElement, wire, api, track } from "lwc";
import getJobPostingDetail from "@salesforce/apex/GDICOE_JobPostingDA.getJobPostingDetail";

export default class Gdicoe_JobPostingDetail extends LightningElement {
  @api storeName;
  @api displayWidth;
  @api buttonCaption;
  @api buttonStyle;
  @api fontSize;
  @api fontWeight;
  @api verticalPadding;
  @api horizontalPadding;
  @api cornerRadius;
  @api backgroundColor;
  @api hoverColor;
  @api textColor;
  @api inactiveCaption;
  @api missingCaption;
  @api buttonTarget;

  _displayWidth = "";
  _buttonCaption = "";
  _anchorStyle = "";
  _spanStyle = "";
  _buttonStyle = "";
  _overStyle = "";
  _outStyle = "";

  @track _dataLoaded = false;
  @track _dataActive = false;
  @track _dataMissing = false;

  _missingCaption = "";
  _inactiveCaption = "";

  _jobId = "";
  _jobData = "";
  _jobName = "";
  _jobLocation = "";
  _jobDescription = "";
  _jobActive = "";

  connectedCallback() {
    this._displayWidth = "width: " + this.displayWidth + "; margin: auto;";
    this._buttonCaption = this.buttonCaption;

    this._anchorStyle += "text-align: center;";
    this._anchorStyle += "font-size: " + this.fontSize + ";";
    this._anchorStyle += "font-weight: " + this.fontWeight + ";";

    this._buttonStyle += "padding-top: " + this.verticalPadding + "px;";
    this._buttonStyle += "padding-bottom: " + this.verticalPadding + "px;";
    this._buttonStyle += "padding-left: " + this.horizontalPadding + "px;";
    this._buttonStyle += "padding-right: " + this.horizontalPadding + "px;";
    this._buttonStyle += "border-radius: " + this.cornerRadius + "px;";
    this._buttonStyle += "color: " + this.textColor + ";";

    this._outStyle =
      this._buttonStyle + "background-color: " + this.backgroundColor + ";";

    this._overStyle =
      this._buttonStyle + "background-color:" + this.hoverColor + ";";

    this._spanStyle = this._outStyle;

    this._inactiveCaption = this.inactiveCaption;
    this._missingCaption = this.missingCaption;
    this._buttonTarget = this.buttonTarget;

    this.getJobData().then((result) => {});
  }

  async getJobData() {
    var url = new URL(document.URL);
    const params = url.searchParams;
    this._urlParam = params.get("empl01");

    this._jobData = await getJobPostingDetail({ jobPostingId: this._urlParam });

    if (this._jobData !== "") {
      var data = this._jobData.split("</>");
      this._jobId = data[0];
      this._jobName = data[1];
      this._jobLocation = data[2];
      this._jobDescription = data[3];
      this._jobActive = data[4];

      this._dataActive = this._jobActive === "true" ? true : false;
      this._dataMissing = false;
    } else {
      this._dataActive = false;
      this._dataMissing = true;
    }
    this._dataLoaded = true;
  }

  _mouseOut(evt) {
    evt.target.setAttribute("style", this._outStyle);
  }

  _mouseOver(evt) {
    evt.target.setAttribute("style", this._overStyle);
  }
}