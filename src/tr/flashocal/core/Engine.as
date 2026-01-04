/**
 * Engine.as
 * Core game engine for FlashOcal.
 * Handles the main loop and initialization.
 */

import tr.flashocal.managers.InputManager;
import tr.flashocal.managers.ScreenManager;
import tr.flashocal.utils.Logger;

class tr.flashocal.core.Engine {
    
    // Singleton instance
    private static var _instance:Engine;
    
    // Managers
    public var inputManager:InputManager;
    public var screenManager:ScreenManager;
    
    // State
    private var _isRunning:Boolean;
    private var _root:MovieClip;
    private var _lastTime:Number;
    
    // Time Control
    public var timeScale:Number;
    private var _accumulator:Number;
    private var _fixedTimeStep:Number; // e.g. 1/60s
    
    // Config
    private var _headless:Boolean;

    /**
     * Private Constructor
     */
    private function Engine(targetRoot:MovieClip, headless:Boolean) {
        Logger.log("Engine initializing... Mode: " + (headless ? "Headless" : "Normal"));
        _root = targetRoot;
        _isRunning = false;
        _headless = (headless == true);
        timeScale = 1.0;
        _accumulator = 0;
        _fixedTimeStep = 0.0166; // approx 60 FPS
        
        // Initialize Managers
        inputManager = InputManager.getInstance();
        
        if (!_headless) {
            screenManager = ScreenManager.getInstance();
            screenManager.init(_root);
        }
    }
    
    /**
     * Entry point for the framework.
     * @param targetRoot The MovieClip where the engine will run (usually _root).
     * @param headless If true, skips rendering.
     */
    public static function init(targetRoot:MovieClip, headless:Boolean):Void {
        if (_instance == null) {
            _instance = new Engine(targetRoot, headless);
            _instance.start();
        }
    }
    
    public static function getInstance():Engine {
        return _instance;
    }
    
    public function setFixedTimeStep(fps:Number):Void {
        if (fps > 0) {
            _fixedTimeStep = 1.0 / fps;
        }
    }
    
    public function start():Void {
        if (_isRunning) return;
        
        _isRunning = true;
        _lastTime = getTimer();
        _accumulator = 0;
        
        // Setup main loop using onEnterFrame
        var scope:Engine = this;
        _root.onEnterFrame = function() {
            scope.update();
        };
        
        Logger.log("Engine started.");
    }
    
    public function stop():Void {
        _isRunning = false;
        delete _root.onEnterFrame;
        Logger.log("Engine stopped.");
    }
    
    private function update():Void {
        var currentTime:Number = getTimer();
        // Prevent huge delta if frame skipped or heavy lag
        var frameTime:Number = (currentTime - _lastTime) / 1000;
        if (frameTime > 0.1) frameTime = 0.1; 
        
        _lastTime = currentTime;
        
        // Accumulate time for physics/logic
        if (tr.flashocal.core.GameStateManager.getInstance().isPlaying()) {
            _accumulator += frameTime * timeScale;
            
            while (_accumulator >= _fixedTimeStep) {
                fixedUpdate(_fixedTimeStep);
                _accumulator -= _fixedTimeStep;
            }
        }
        
        // Input and Render update (every frame)
        // In headless, we might mock inputs or receive them from network
        inputManager.update();
        
        if (!_headless) {
            // Pass interpolation alpha if needed: _accumulator / _fixedTimeStep
            screenManager.update(frameTime * timeScale); 
        }
        
        // Performance Monitor
        tr.flashocal.core.PerformanceMonitor.getInstance().monitorFrame(frameTime);
    }
    
    private function fixedUpdate(dt:Number):Void {
        // Logic that requires fixed timestep (Physics, AI)
        // This could be dispatched as an event or called on managers
        // For now, let's assume ScreenManager handles it or we dispatch a separate event
        // screenManager.fixedUpdate(dt); // If ScreenManager supports it
    }
}
