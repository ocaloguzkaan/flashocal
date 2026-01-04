import tr.flashocal.utils.Logger;

class tr.flashocal.core.PrefabFactory {
    
    private static var _instance:PrefabFactory;
    private var _definitions:Object; // Stores parsed JSON/XML data for types

    private function PrefabFactory() {
        _definitions = new Object();
    }

    public static function getInstance():PrefabFactory {
        if (_instance == null) {
            _instance = new PrefabFactory();
        }
        return _instance;
    }
    
    public function loadDefinitions(data:Object):Void {
        // Expected format: { "SportCar": { linkage:"car_mc", speed: 20, color: 0xFF0000 }, ... }
        _definitions = data;
    }
    
    public function create(type:String, targetContext:MovieClip, x:Number, y:Number):Object {
        var def:Object = _definitions[type];
        if (!def) {
            Logger.log("[PrefabFactory] Error: Definition not found for " + type);
            return null;
        }
        
        var d:Number = targetContext.getNextHighestDepth();
        var name:String = type + "_" + d;
        
        // 1. Create/Attach View
        var mc:MovieClip;
        if (def.linkage) {
            mc = targetContext.attachMovie(def.linkage, name, d);
        } else {
            // Procedural fallback
            targetContext.createEmptyMovieClip(name, d);
            mc = targetContext[name];
            drawPlaceholder(mc, def.color || 0xCCCCCC);
        }
        
        mc._x = x;
        mc._y = y;
        
        // 2. Apply Properties
        var obj:Object = new Object(); // Could be a specific class wrapper if AS2 allowed dynamic class instantiation easily by string
        obj.view = mc;
        obj.type = type;
        
        // Copy props
        for (var k:String in def) {
            if (k != "linkage") {
                obj[k] = def[k];
            }
        }
        
        return obj;
    }
    
    private function drawPlaceholder(mc:MovieClip, color:Number):Void {
        mc.beginFill(color);
        mc.moveTo(-10, -10);
        mc.lineTo(10, -10);
        mc.lineTo(10, 10);
        mc.lineTo(-10, 10);
        mc.lineTo(-10, -10);
        mc.endFill();
    }
}
