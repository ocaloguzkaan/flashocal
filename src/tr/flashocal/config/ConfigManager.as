import tr.flashocal.utils.Logger;

class tr.flashocal.config.ConfigManager {
    
    private static var _instance:ConfigManager;
    private var _config:Object;

    private function ConfigManager() {
        _config = new Object();
    }

    public static function getInstance():ConfigManager {
        if (_instance == null) {
            _instance = new ConfigManager();
        }
        return _instance;
    }
    
    public function loadConfig(configData:Object):Void {
        _config = configData;
        Logger.log("[ConfigManager] Config loaded.");
    }
    
    public function getNumber(key:String, defaultValue:Number):Number {
        if (_config[key] != undefined) {
             return Number(_config[key]);
        }
        return defaultValue;
    }
    
    public function getString(key:String, defaultValue:String):String {
        if (_config[key] != undefined) {
             return String(_config[key]);
        }
        return defaultValue;
    }
    
    public function getBoolean(key:String, defaultValue:Boolean):Boolean {
        if (_config[key] != undefined) {
             return (_config[key] == "true" || _config[key] == true);
        }
        return defaultValue;
    }
    
    public function getObject(key:String):Object {
        return _config[key];
    }
}
