import { LightningElement, track, api } from "lwc";
import getJobDetailPayloadAsJSON from "@salesforce/apex/GDICOE_JobPostingDA.getJobDetailPayloadAsJSON";

export default class Gdicoe_JobPostingDetail extends LightningElement {
  @api displayLanguage;
  @api noneCaption;

  @track _isLoaded = false;

  _postingId = null;
  _jsonPayload = null;
  _templateMap = null;
  _translationMap = null;
  _fieldMap = null;
  _languageMap = null;

  //consoleLog(key, value) {
  //  console.log(key);
  //  console.log(value);
  //}

  connectedCallback() {}

  renderedCallback() {
    this.getPageData().then((result) => {});
  }

  async getPageData() {
    // jobDetailId
    var url = new URL(document.URL);
    const params = url.searchParams;
    this._postingId = params.get("_id");
    //this.consoleLog("detail is", this._detailId);

    // payload
    //console.log("getting payload : " + this.displayLanguage);
    this._jsonPayload = await getJobDetailPayloadAsJSON({
      jobPostingId: this._postingId,
      displayLanguage: this.displayLanguage,
    });
    this._jsonPayload = this.jsonToMap(this._jsonPayload);
    //this.consoleLog("got payload", this._jsonPayload);

    this._templateMap = this.jsonToMap(this._jsonPayload.get("template"));
    //this.consoleLog("template map is", this._templateMap);

    this._fieldMap = this.jsonToMap(this._jsonPayload.get("field"));
    this._fieldMap = this.preprocessFields(this._fieldMap);
    //this.consoleLog("field map is", this._fieldMap);

    this._translationMap = this.jsonToMap(this._jsonPayload.get("translation"));
    for ( var key of this._templateMap.keys() ) {
      this._translationMap.set(key,this._templateMap.get(key));
    }
    //this.consoleLog("translation map is", this._translationMap);

    this._languageMap = this.jsonToMap('{ "DISPLAY_LANGUAGE" : "' + this.displayLanguage + '"}');
    //this.consoleLog("language map is", this._languageMap);


    // generate page
    this.generatePage();
  }

  generatePage() {
    var innerHTMLcontainer = this.template.querySelector(
      ".gdicoe_jobpostingdetail_innerHTMLcontainer"
    );
    //console.log("innerHTMLcontainer");
    if (innerHTMLcontainer == null) {
      //console.log("innerHTMLcontainer is null");
      this._isLoaded = false;
    } else {
      //console.log("innerHTMLcontainer is not null");

      var htmlContent =
        "<style type='text/css'>" +
        this._templateMap.get("CssText__c") +
        "</style>" +
        this._templateMap.get("HtmlText__c");

      //this.consoleLog("html content", htmlContent);

      if ( this._fieldMap.size > 0 ) {
        htmlContent = this.searchAndReplace(htmlContent, this._languageMap);
        htmlContent = this.searchAndReplace(htmlContent, this._fieldMap);
        htmlContent = this.searchAndReplace(htmlContent, this._translationMap);
      } else {
        htmlContent = this.noneCaption;
      }

      innerHTMLcontainer.innerHTML = 
        "<div class='gdicoe_jobpostingdetail_unavailable'>" 
        + htmlContent
        + "</div>";
      this._isLoaded = true;
    }
  }

  jsonToMap(jsonSource) {
    return new Map(Object.entries(JSON.parse(jsonSource)));
  }

  searchAndReplace(stringValue, stringMap) {
    var result = stringValue;
    var pattern = "";

    for (var key of stringMap.keys()) {
      //this.consoleLog("search", key);

      try {
        if (key.charAt(0) == "/") {
          pattern = new RegExp("[/]" + key.substring(1), "g");
        } else {
          pattern = new RegExp("__" + key + "__", "g");
        }

        //this.consoleLog("replace", pattern);
        result = result.replace(pattern, stringMap.get(key));
      } catch {
        //console.log('replace exception');        
        result = result.replace(pattern, "");
      }
    }

    return result;
  }

  preprocessFields(fieldMap) {
    var result = new Map();

    var pattern = new RegExp(
      'src="http(s)?[:][/][/].*[/]file-asset(-public)?/',
      "g"
    );

    for (var key of fieldMap.keys()) {
      var value = fieldMap.get(key);
      if (value == null) {
        value = "";
      }
      result.set(key, value.replace(pattern, 'src="/'));
    }

    return result;
  }
}
