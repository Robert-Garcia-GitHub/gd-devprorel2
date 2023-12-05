import { LightningElement, api } from 'lwc';

export default class GDICOEGenericButton extends LightningElement {
    // properties that come from the Experience builder
    @api genericButton_displayText
    @api genericButton_fontSize
    @api genericButton_fontWeight
    @api genericButton_targetUrl
    @api genericButton_blankTarget
    @api genericButton_buttonAlignment
    @api genericButton_buttonPadding
    @api genericButton_buttonRadius
    @api genericButton_backgroundColor
    @api genericButton_hoverColor
    @api genericButton_textColor
    
    // this is used to set the div style that holds the button (which is an anchor that holds a span)
    genericButton_divStyle = ""

    // these are used to set the anchor style and attributes
    genericButton_anchorStyle = ""
    genericButton_anchorHref = ""
    genericButton_anchorTarget = ""

    // these are used to set the span style and attributes
    genericButton_spanStyle = ""
    genericButton_spanText = ""

    // these are used to implement the hover effect on the button
    genericButton_mouseOverStyle = "";
    genericButton_mouseOutStyle = "";
 
    // when the component is ready, pass the Experience builder properties to it
    connectedCallback() {
        // set up the outer div style, which lets us align the button
        this.genericButton_divStyle = "text-decoration:none !important;"
        this.genericButton_divStyle += "text-align: " + this.genericButton_buttonAlignment + ";"

        // set up the anchor style
        this.genericButton_anchorStyle = "text-decoration:none !important;"
        this.genericButton_anchorStyle += "font-size:" + this.genericButton_fontSize + " !important;"
        this.genericButton_anchorStyle += "font-weight:" + this.genericButton_fontWeight + " !important;"
        // set up the anchor link and target
        this.genericButton_anchorHref = this.genericButton_targetUrl
        if ( this.genericButton_blankTarget === "yes") {
            this.genericButton_anchorTarget = "_blank"
        }

        // set up the "mouse over" style for the button
        this.genericButton_mouseOutStyle = "background-color:" + this.genericButton_backgroundColor + " !important;"
        this.genericButton_mouseOutStyle += "color:" + this.genericButton_textColor + " !important;"         
        this.genericButton_mouseOutStyle += "padding:" + this.genericButton_buttonPadding + "px !important;"
        this.genericButton_mouseOutStyle += "border-radius:" + this.genericButton_buttonRadius + "px !important;"
        
        // set up the "mouse out" style for the button
        this.genericButton_mouseOverStyle = "background-color:" + this.genericButton_hoverColor + " !important;"
        this.genericButton_mouseOverStyle += "color:" + this.genericButton_textColor + " !important;"         
        this.genericButton_mouseOverStyle += "padding:" + this.genericButton_buttonPadding + "px !important;"
        this.genericButton_mouseOverStyle += "border-radius:" + this.genericButton_buttonRadius + "px !important;"

        // set up the span style and text, which lets us set up the button's caption
        this.genericButton_spanStyle = this.genericButton_mouseOutStyle;
        this.genericButton_spanText = this.genericButton_displayText
    }

    genericButton_mouseOut (evt) {
        evt.target.setAttribute("style", this.genericButton_mouseOutStyle)
    }

    genericButton_mouseOver (evt) {
        evt.target.setAttribute("style", this.genericButton_mouseOverStyle)
    }
}