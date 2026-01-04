/**
 * Label.as
 * Simple Wrapper for a Textfield.
 */
 
class tr.flashocal.ui.Label {
    
    public var mc:MovieClip;
    private var _tf:TextField;
    
    public function Label(targetMC:MovieClip, initText:String) {
        mc = targetMC;
        if (mc.label_txt == undefined) {
             mc.createTextField("label_txt", 1, 0, 0, 100, 20);
        }
        _tf = mc.label_txt;
         // Default styling
        var fmt:TextFormat = new TextFormat();
        fmt.font = "_sans";
        fmt.size = 12;
        fmt.color = 0x000000;
        _tf.setNewTextFormat(fmt);
        _tf.text = (initText == undefined) ? "Label" : initText;
        _tf.autoSize = "left";
        _tf.selectable = false;
    }
    
    public function set text(val:String):Void {
        _tf.text = val;
    }
    
    public function get text():String {
        return _tf.text;
    }
    
    public function set color(val:Number):Void {
        _tf.textColor = val;
    }
}
