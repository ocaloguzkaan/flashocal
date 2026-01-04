/**
 * Button.as
 * A flexible UI Button wrapper for MovieClips.
 * Supports: custom states, callbacks, and simple effects.
 */

import tr.flashocal.events.EventDispatcher;
import tr.flashocal.events.Event;


class tr.flashocal.ui.Button extends EventDispatcher {
    
    public var mc:MovieClip;
    private var _enabled:Boolean;
    
    // Event types
    public static var CLICK:String = "click";
    public static var HOVER:String = "hover";
    public static var OUT:String = "out";
    
    public function Button(targetMC:MovieClip) {
        super();
        mc = targetMC;
        _enabled = true;
        
        initHandlers();
        
        // Stop on first frame (usually "up" state)
        mc.stop();
    }
    
    private function initHandlers():Void {
        var scope:Button = this;
        
        mc.onRollOver = function() {
            if (!scope._enabled) return;
            scope.dispatchEvent(new Event(Button.HOVER, { target: scope }));
            this.gotoAndStop("_over"); // Expects frame label "_over"
        };
        
        mc.onRollOut = mc.onReleaseOutside = function() {
            if (!scope._enabled) return;
            scope.dispatchEvent(new Event(Button.OUT, { target: scope }));
            this.gotoAndStop("_up"); // Expects frame label "_up"
        };
        
        mc.onPress = function() {
             if (!scope._enabled) return;
             this.gotoAndStop("_down"); // Expects frame label "_down"
        };
        
        mc.onRelease = function() {
            if (!scope._enabled) return;
            scope.dispatchEvent(new Event(Button.CLICK, { target: scope }));
            this.gotoAndStop("_over");
        };
    }
    
    public function set text(str:String):Void {
        // Assumes there is a TextField named 'label_txt' inside
        if (mc.label_txt != undefined) {
             mc.label_txt.text = str;
        }
    }
    
    public function get text():String {
        if (mc.label_txt != undefined) {
             return mc.label_txt.text;
        }
        return "";
    }
    
    public function set enabled(val:Boolean):Void {
        _enabled = val;
        mc.enabled = val;
        if (!_enabled) {
            mc.gotoAndStop("_disabled"); // Optional frame
        } else {
            mc.gotoAndStop("_up");
        }
    }
    
    public function get enabled():Boolean {
        return _enabled;
    }
    
    public function destroy():Void {
        delete mc.onRollOver;
        delete mc.onRollOut;
        delete mc.onRelease;
        delete mc.onPress;
        delete mc.onReleaseOutside;
        mc.removeMovieClip();
    }
}
