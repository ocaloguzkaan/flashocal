/**
 * EventDispatcher.as
 * Mixin or Base class for event dispatching.
 */

import tr.flashocal.events.Event;

class tr.flashocal.events.EventDispatcher {
    
    private var _listeners:Object;
    
    public function EventDispatcher() {
        _listeners = new Object();
    }
    
    public function addEventListener(type:String, scope:Object, callback:String):Void {
        if (_listeners[type] == undefined) {
            _listeners[type] = new Array();
        }
        _listeners[type].push({scope: scope, callback: callback});
    }
    
    public function removeEventListener(type:String, scope:Object, callback:String):Void {
        var list:Array = _listeners[type];
        if (list == undefined) return;
        
        for (var i:Number = 0; i < list.length; i++) {
            if (list[i].scope == scope && list[i].callback == callback) {
                list.splice(i, 1);
                return;
            }
        }
    }
    
    public function dispatchEvent(event:Event):Void {
        if (event.target == undefined) {
            event.target = this;
        }
        
        var list:Array = _listeners[event.type];
        if (list == undefined) return;
        
        // Clone list to handle removals during dispatch safely
        var executeList:Array = list.concat();
        
        for (var i:Number = 0; i < executeList.length; i++) {
            var listener:Object = executeList[i];
            listener.scope[listener.callback](event);
        }
    }
}
