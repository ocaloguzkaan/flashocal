import tr.flashocal.utils.Logger;

class tr.flashocal.managers.LevelManager {
    
    private static var _instance:LevelManager;
    private var _currentLevelData:Object;
    private var _listeners:Array;

    private function LevelManager() {
        _listeners = new Array();
    }

    public static function getInstance():LevelManager {
        if (_instance == null) {
            _instance = new LevelManager();
        }
        return _instance;
    }

    public function loadLevel(levelData:Object):Void {
        Logger.log("[LevelManager] Loading level...");
        _currentLevelData = levelData;
        parseLevelData();
    }

    private function parseLevelData():Void {
        if (_currentLevelData == null) {
            Logger.log("[LevelManager] Error: No level data to parse.");
            return;
        }

        if (_currentLevelData.track != null) {
            buildTrack(_currentLevelData.track);
        }
        
        if (_currentLevelData.obstacles != null) {
            placeObstacles(_currentLevelData.obstacles);
        }

        Logger.log("[LevelManager] Level built successfully.");
        dispatchEvent({type: "onLevelLoaded"});
    }

    private function buildTrack(trackPoints:Array):Void {
        // Implementation
        Logger.log("[LevelManager] Building track with " + trackPoints.length + " points.");
    }

    private function placeObstacles(obstacles:Array):Void {
        // Implementation
        Logger.log("[LevelManager] Placing " + obstacles.length + " obstacles.");
    }
    
    public function getCurrentLevelData():Object {
        return _currentLevelData;
    }
    
    public function addEventListener(listener:Object):Void {
        _listeners.push(listener);
    }

    private function dispatchEvent(event:Object):Void {
        for (var i:Number = 0; i < _listeners.length; i++) {
            var l:Object = _listeners[i];
            if (l.onLevelEvent) {
                l.onLevelEvent(event);
            }
        }
    }
}
