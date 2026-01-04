import tr.flashocal.utils.Logger;

class tr.flashocal.core.ServiceLocator {
    
    private static var _instance:ServiceLocator;
    private var _services:Object;

    private function ServiceLocator() {
        _services = new Object();
    }

    public static function getInstance():ServiceLocator {
        if (_instance == null) {
            _instance = new ServiceLocator();
        }
        return _instance;
    }
    
    /**
     * Registers a service instance under a specific key/interface name.
     */
    public function register(key:String, service:Object):Void {
        if (_services[key] != undefined) {
            Logger.log("[ServiceLocator] Warning: Overwriting service " + key);
        }
        _services[key] = service;
        Logger.log("[ServiceLocator] Registered: " + key);
    }
    
    /**
     * Retrieves a service. Returns null if not found.
     */
    public function getService(key:String):Object {
        var s:Object = _services[key];
        if (s == null) {
            Logger.log("[ServiceLocator] Error: Service " + key + " not found.");
        }
        return s;
    }
    
    public function remove(key:String):Void {
        delete _services[key];
    }
}
