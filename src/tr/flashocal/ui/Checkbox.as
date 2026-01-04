/**
 * Checkbox.as
 * Simple Checkbox UI component.
 */

import tr.flashocal.events.EventDispatcher;
import tr.flashocal.events.Event;

class tr.flashocal.ui.Checkbox extends EventDispatcher {
    
    public var mc:MovieClip;
    private var _checked:Boolean;
    private var _label:String;
    
    public static var CHANGE:String = "change";
    
    public function Checkbox(targetMC:MovieClip, labelText:String) {
        super();
        mc = targetMC;
        _label = (labelText == undefined) ? "Checkbox" : labelText;
        _checked = false;
        
        draw();
        initHandlers();
        
        mc.stop();
    }
    
    private function draw():Void {
        // Assume MC has "checked" and "unchecked" frames or we just use code to draw/modify?
        // For a framework, best to rely on frames if designer provided, OR draw if strictly code.
        // Let's assume the user provides an MC with "on" and "off" frames? 
        // Or simpler: We just toggle a child 'check' visibility.
        
        if (mc.label_txt == undefined) {
             mc.createTextField("label_txt", 2, 15, 0, 100, 20);
             mc.label_txt.autoSize = "left";
             mc.label_txt.selectable = false;
             var fmt:TextFormat = new TextFormat();
             fmt.font = "_sans";
             fmt.size = 12;
             mc.label_txt.setNewTextFormat(fmt);
        }
        mc.label_txt.text = _label;
        
        updateState();
    }
    
    private function initHandlers():Void {
        var scope:Checkbox = this;
        mc.onRelease = function() {
            scope.checked = !scope.checked;
            scope.dispatchEvent(new Event(Checkbox.CHANGE, { target: scope, checked: scope.checked }));
        };
    }
    
    public function set checked(val:Boolean):Void {
        _checked = val;
        updateState();
    }
    
    public function get checked():Boolean {
        return _checked;
    }
    
    private function updateState():Void {
        if (_checked) {
            mc.gotoAndStop("on");
            // If strictly code-based fallback
            if (mc._totalframes == 1) {
                // draw check?
            }
        } else {
            mc.gotoAndStop("off");
        }
    }
}
