import tr.flashocal.utils.Logger;
import tr.flashocal.core.ServiceLocator;

class tr.flashocal.core.PerformanceMonitor {
    
    private static var _instance:PerformanceMonitor;
    
    private var _frameBudgetMs:Number;
    private var _lowFpsFrameCount:Number;
    private var _quality:String; // "HIGH", "MEDIUM", "LOW"
    
    private function PerformanceMonitor() {
        _frameBudgetMs = 33; // ~30 FPS
        _lowFpsFrameCount = 0;
        _quality = "HIGH";
    }

    public static function getInstance():PerformanceMonitor {
        if (_instance == null) {
            _instance = new PerformanceMonitor();
        }
        return _instance;
    }
    
    public function monitorFrame(dt:Number):Void {
        // dt is in seconds
        var ms:Number = dt * 1000;
        
        if (ms > _frameBudgetMs + 5) { // 5ms buffer
            _lowFpsFrameCount++;
        } else {
            if (_lowFpsFrameCount > 0) _lowFpsFrameCount--;
        }
        
        // If consistent low FPS for 60 frames (approx 2 sec)
        if (_lowFpsFrameCount > 60) {
            downgradeQuality();
            _lowFpsFrameCount = 0; // Reset to see if it helped
        }
    }
    
    private function downgradeQuality():Void {
        if (_quality == "HIGH") {
            _quality = "MEDIUM";
            Logger.log("[PerformanceMonitor] Downgrading to MEDIUM quality.");
            
            // Example optimization: Disable Particles
            // var fx:Object = ServiceLocator.getInstance().getService("particles");
            // if (fx) fx.setEnabled(false);
            
            // Or reduce visuals
            _root._quality = "MEDIUM";
            
        } else if (_quality == "MEDIUM") {
            _quality = "LOW";
            Logger.log("[PerformanceMonitor] Downgrading to LOW quality.");
             _root._quality = "LOW";
             
             // Disable Filters
             // var effectMgr:Object = ServiceLocator.getInstance().getService("effects");
             // if (effectMgr) effectMgr.clearAll();
        }
    }
    
    public function get currentQuality():String {
        return _quality;
    }
}
