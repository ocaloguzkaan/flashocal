class tr.flashocal.events.Signal {
    
    private var _listeners:Array;
    
    public function Signal() {
        _listeners = new Array();
    }
    
    public function add(listener:Function, scope:Object):Void {
        // Check duplication?
        _listeners.push({fn: listener, sc: scope});
    }
    
    public function remove(listener:Function, scope:Object):Void {
        for (var i:Number = 0; i < _listeners.length; i++) {
            var item:Object = _listeners[i];
            if (item.fn == listener && item.sc == scope) {
                _listeners.splice(i, 1);
                return;
            }
        }
    }
    
    public function dispatch(args:Object):Void { // ...args not supported in AS2 cleanly, usually we pass one data object
        for (var i:Number = 0; i < _listeners.length; i++) {
            var item:Object = _listeners[i];
            var f:Function = item.fn;
            var s:Object = item.sc;
            
            f.apply(s, arguments); // pass all arguments properly
        }
    }
    
    public function removeAll():Void {
        _listeners = new Array();
    }
}
