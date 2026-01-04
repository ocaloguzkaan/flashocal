/**
 * SaveManager.as
 * Wrapper for SharedObject to persist local data.
 */

class tr.flashocal.managers.SaveManager {
    
    private static var _so:SharedObject;
    private static var _name:String = "flashocal_save_data";
    
    public static function init(name:String):Void {
        if (name != undefined) _name = name;
        _so = SharedObject.getLocal(_name);
    }
    
    public static function set data(obj:Object):Void {
        if (!_so) init();
        for (var i:String in obj) {
            _so.data[i] = obj[i];
        }
        flush();
    }
    
    public static function get data():Object {
        if (!_so) init();
        return _so.data;
    }
    
    public static function save(key:String, value:Object):Void {
        if (!_so) init();
        _so.data[key] = value;
        flush();
    }
    
    public static function load(key:String):Object {
        if (!_so) init();
        return _so.data[key];
    }
    
    public static function flush():Void {
        if (_so) _so.flush();
    }
    
    public static function clear():Void {
        if (_so) _so.clear();
    }
}
