import { LightningElement, wire, api, track } from "lwc";
import getJobPostingListData from "@salesforce/apex/GDICOE_JobPostingDA.getJobPostingListData";

export default class Gdicoe_JobPostingList extends LightningElement {
  @api storeName;
  @api displayLanguage;
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
  @api detailPage;
  @api noneCaption;

  _displayWidth = "";
  _buttonCaption = "";
  _anchorStyle = "";
  _anchorPage = "";
  _spanStyle = "";
  _buttonStyle = "";
  _overStyle = "";
  _outStyle = "";
  _noneCaption = "";

  @track _isLoaded = false;
  @track _hasData = false;
  @track _jobPostingListData;

  @wire(getJobPostingListData, {
    storeName: "$storeName",
    displayLanguage: "$displayLanguage"
  })
  wiredJobPostingListData({error, data}) {
    if ( data ) {
      this._jobPostingListData = data;
      console.log("JOBPOSTINGDATA");
      console.log(this.storeName);
      console.log(this.displayLanguage);
      console.log(this._jobPostingListData);
      this._hasData = ( data.length > 0 );
      this._isLoaded = true;
    } else if ( error ) {
      this._jobPostingListData = null;
      this._hasData  = false;
      this._isLoaded = true;
    }
  }

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

    this._anchorHref = this.detailPage;

    this._noneCaption = this.noneCaption;
  }

  _mouseOut(evt) {
    evt.target.setAttribute("style", this._outStyle);
  }

  _mouseOver(evt) {
    evt.target.setAttribute("style", this._overStyle);
  }

  convertToUrlFormat(value) {
    return value.toLowerCase().replace(/\s/g, "-");
  }
  
  _handleAnchor(evt) {
    let href = this.detailPage;
    href += "?_ref=" + this.convertToUrlFormat(evt.currentTarget.dataset.name);
    href += "--" + this.convertToUrlFormat(evt.currentTarget.dataset.location);
    href += "&_id=" + evt.currentTarget.dataset.id;
    window.location.href = href;
  }
}