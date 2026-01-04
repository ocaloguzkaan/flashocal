/**
 * SimpleTween.as
 * A lightweight tweening engine for AS2.
 * Usage: SimpleTween.to(myMC, 1.0, { _x: 100, _alpha: 50 }, "easeOut");
 */

import tr.flashocal.core.Engine;

class tr.flashocal.motion.SimpleTween {
    
    private static var _tweens:Array = new Array();
    private static var _isInitialized:Boolean = false;
    
    public var target:Object;
    public var props:Object;
    public var startProps:Object;
    public var duration:Number;
    public var timePassed:Number;
    public var easeType:String;
    public var onComplete:Function;
    public var onCompleteScope:Object;
    
    public function SimpleTween(t:Object, d:Number, p:Object, ease:String) {
        target = t;
        duration = d;
        props = p;
        startProps = new Object();
        timePassed = 0;
        easeType = (ease == undefined) ? "linear" : ease;
        
        for (var name:String in props) {
            startProps[name] = target[name];
        }
    }
    
    public static function to(target:Object, duration:Number, props:Object, ease:String, callback:Function, scope:Object):SimpleTween {
        if (!_isInitialized) init();
        
        var tween:SimpleTween = new SimpleTween(target, duration, props, ease);
        if (callback != undefined) {
            tween.onComplete = callback;
            tween.onCompleteScope = scope;
        }
        _tweens.push(tween);
        return tween;
    }
    
    private static function init():Void {
        _isInitialized = true;
        var root:MovieClip = Engine.getInstance() == null ? _root : Engine.getInstance()["_root"];
        
        if (root.tweenController == undefined) {
             root.createEmptyMovieClip("tweenController", 12345);
        }
        
        root.tweenController.onEnterFrame = function() {
            SimpleTween.update();
        };
    }
    
    public static function update():Void {
        if (_tweens.length == 0) return;
        
        // Use a simple dt approximation or getTimer
        var dt:Number = 1/30; // Assume 30FPS for simplicity in AS2 if Engine Delta not passed
        
        for (var i:Number = _tweens.length - 1; i >= 0; i--) {
            var t:SimpleTween =  _tweens[i];
            t.timePassed += dt;
            
            if (t.timePassed >= t.duration) {
                t.timePassed = t.duration;
                t.apply();
                if (t.onComplete != undefined) {
                    t.onComplete.apply(t.onCompleteScope);
                }
                _tweens.splice(i, 1);
            } else {
                t.apply();
            }
        }
    }
    
    public function apply():Void {
        var t:Number = timePassed / duration;
        var f:Number = getEase(t, easeType);
        
        for (var name:String in props) {
            var startVal:Number = startProps[name];
            var endVal:Number = props[name];
            target[name] = startVal + (endVal - startVal) * f;
        }
    }
    
    private function getEase(t:Number, type:String):Number {
        switch(type) {
            case "easeOut": return t * (2 - t);
            case "easeIn": return t * t;
            case "easeInOut": return t < .5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
            default: return t;
        }
    }
}
