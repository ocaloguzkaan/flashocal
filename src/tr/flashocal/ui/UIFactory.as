class tr.flashocal.ui.UIFactory {
    
    // Creates a simple generic button logic wrapper
    // In AS2, we usually need an existing MovieClip in the library or create one.
    // This factory assumes we are decorating an existing MovieClip or creating a placeholder.
    
    public static function createButton(target:MovieClip, label:String, callback:Function, scope:Object):Void {
        // Draw simple generic button if empty
        if (target._width == 0) {
            target.beginFill(0x333333);
            target.drawRect(0, 0, 100, 30);
            target.endFill();
        }
        
        // Add Label (requires dynamic text field creation)
        target.createTextField("lbl", target.getNextHighestDepth(), 0, 5, target._width, 20);
        target.lbl.text = label;
        target.lbl.selectable = false;
        var fmt:TextFormat = new TextFormat();
        fmt.align = "center";
        fmt.color = 0xFFFFFF;
        target.lbl.setTextFormat(fmt);
        
        // Interactivity
        target.onRollOver = function() {
            this._alpha = 80;
        };
        target.onRollOut = function() {
            this._alpha = 100;
        };
        target.onRelease = function() {
            if (callback) {
                callback.apply(scope);
            }
        };
    }
    
    // Create a Theme-based background
    public static function createPanel(target:MovieClip, w:Number, h:Number):Void {
        target.clear();
        target.lineStyle(1, 0x666666);
        target.beginFill(0x222222, 90);
        target.moveTo(0,0);
        target.lineTo(w, 0);
        target.lineTo(w, h);
        target.lineTo(0, h);
        target.endFill();
    }
}
