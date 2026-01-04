/**
 * ObjectPool.as
 * Generic object pooling system.
 */

class tr.flashocal.utils.ObjectPool {
    
    private var _pool:Array;
    private var _classRef:Function; // Constructor function
    private var _initProps:Object; // Optional init object
    
    public function ObjectPool(classRef:Function, initialSize:Number, initProps:Object) {
        _classRef = classRef;
        _initProps = initProps;
        _pool = new Array();
        
        for (var i:Number = 0; i < initialSize; i++) {
            _pool.push(createNew());
        }
    }
    
    private function createNew():Object {
        // AS2 doesn't have a clean generic 'new Class()'.
        // We usually have to rely on passing a factory function or using logic.
        // Simple workaround: 
        // If classRef is provided, try 'new classRef()'.
        
        var obj:Object = new _classRef();
        // If it's a MovieClip wrapper, it might need args. 
        // This is a basic implementation for logic classes or simple objects.
        return obj;
    }
    
    public function get():Object {
        if (_pool.length > 0) {
            return _pool.pop();
        } else {
            return createNew();
        }
    }
    
    public function put(obj:Object):Void {
        _pool.push(obj);
    }
}
