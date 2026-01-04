/**
 * InputManager.as
 * Handles global keyboard input.
 */

class tr.flashocal.managers.InputManager {
    
    private static var _instance:InputManager;
    private var _keysHandlers:Array; // Array of key states
    private var _keyListener:Object;
    
    // Key Constants (Commonly used)
    public static var LEFT:Number = 37;
    public static var UP:Number = 38;
    public static var RIGHT:Number = 39;
    public static var DOWN:Number = 40;
    public static var SPACE:Number = 32;
    public static var ENTER:Number = 13;
    
    private function InputManager() {
        _keysHandlers = new Array();
        _keyListener = new Object();
        
        var scope:InputManager = this;
        
        _keyListener.onKeyDown = function() {
            scope._keysHandlers[Key.getCode()] = true;
        };
        
        _keyListener.onKeyUp = function() {
            scope._keysHandlers[Key.getCode()] = false;
        };
        
        Key.addListener(_keyListener);
    }
    
    public static function getInstance():InputManager {
        if (_instance == null) {
            _instance = new InputManager();
        }
        return _instance;
    }
    
    public function update():Void {
        // Can be used for "Just Pressed" logic if needed
    }
    
    /**
     * Checks if a specific key is currently held down.
     */
    public function isDown(keyCode:Number):Boolean {
        return (_keysHandlers[keyCode] == true);
    }
    
    public function destroy():Void {
        Key.removeListener(_keyListener);
        _instance = null;
    }
}
