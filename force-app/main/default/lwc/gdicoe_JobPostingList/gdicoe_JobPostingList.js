import { LightningElement, wire, api, track } from "lwc";
import getJobPostingList from "@salesforce/apex/GDICOE_JobPostingDA.getJobPostingList";

export default class Gdicoe_JobPostingList extends LightningElement {
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
  @api detailPage;

  _displayWidth = "";
  _buttonCaption = "";
  _anchorStyle = "";
  _anchorPage = "";
  _spanStyle = "";
  _buttonStyle = "";
  _overStyle = "";
  _outStyle = "";

  @wire(getJobPostingList, { storeName: "$storeName" }) wiredJobPostings;

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
  }

  _mouseOut(evt) {
    evt.target.setAttribute("style", this._outStyle);
  }

  _mouseOver(evt) {
    evt.target.setAttribute("style", this._overStyle);
  }

  _handleAnchor(evt) {
    window.location.href = this.detailPage + "?empl01=" + evt.currentTarget.dataset.id;
  }
}