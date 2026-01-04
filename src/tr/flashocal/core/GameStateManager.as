import tr.flashocal.utils.Logger;

class tr.flashocal.core.GameStateManager {
    public static var STATE_MENU:String = "STATE_MENU";
    public static var STATE_PLAYING:String = "STATE_PLAYING";
    public static var STATE_PAUSED:String = "STATE_PAUSED";
    public static var STATE_GAME_OVER:String = "STATE_GAME_OVER";
    public static var STATE_CINEMATIC:String = "STATE_CINEMATIC";

    private static var _instance:GameStateManager;
    private var _currentState:String;
    private var _previousState:String;
    
    private var _listeners:Array;

    private function GameStateManager() {
        _currentState = STATE_MENU;
        _listeners = new Array();
    }

    public static function getInstance():GameStateManager {
        if (_instance == null) {
            _instance = new GameStateManager();
        }
        return _instance;
    }

    public function getCurrentState():String {
        return _currentState;
    }

    public function changeState(newState:String):Void {
        if (_currentState == newState) return;

        _previousState = _currentState;
        _currentState = newState;
        
        Logger.log("[GameStateManager] State changed to: " + _currentState);
        dispatchEvent({type: "onChange", currentState: _currentState});
    }

    public function pauseGame():Void {
        if (_currentState == STATE_PLAYING) {
            changeState(STATE_PAUSED);
        }
    }

    public function resumeGame():Void {
        if (_currentState == STATE_PAUSED) {
            changeState(STATE_PLAYING);
        }
    }
    
    public function isPlaying():Boolean {
        return _currentState == STATE_PLAYING;
    }
    
    public function isPaused():Boolean {
        return _currentState == STATE_PAUSED;
    }
    
    public function addEventListener(listener:Object):Void {
        _listeners.push(listener);
    }

    private function dispatchEvent(event:Object):Void {
        for (var i:Number = 0; i < _listeners.length; i++) {
            var l:Object = _listeners[i];
            // Simple callback system
            if (l.onGameStateChange) {
                l.onGameStateChange(event);
            }
        }
    }
}
