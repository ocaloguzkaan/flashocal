/**
 * ScreenManager.as
 * Manages the current active screen of the game.
 */

import tr.flashocal.core.IScreen;
import tr.flashocal.utils.Logger;

class tr.flashocal.managers.ScreenManager {
    
    private static var _instance:ScreenManager;
    private var _currentScreen:IScreen;
    private var _root:MovieClip;
    
    private function ScreenManager() {
    }
    
    public static function getInstance():ScreenManager {
        if (_instance == null) {
            _instance = new ScreenManager();
        }
        return _instance;
    }
    
    public function init(rootMC:MovieClip):Void {
        _root = rootMC;
    }
    
    public function changeScreen(newScreen:IScreen):Void {
        if (_currentScreen != null) {
            _currentScreen.onExit();
        }
        
        _currentScreen = newScreen;
        
        if (_currentScreen != null) {
            Logger.log("Switched to new screen.");
            _currentScreen.onEnter();
        }
    }
    
    public function update(dt:Number):Void {
        if (_currentScreen != null) {
            _currentScreen.update(dt);
        }
    }
}
