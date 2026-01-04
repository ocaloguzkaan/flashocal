import tr.flashocal.managers.ScreenManager;
import flash.geom.Matrix;

class tr.flashocal.managers.TransitionManager {
    
    private static var _instance:TransitionManager;
    private var _overlay:MovieClip;
    private var _onComplete:Function;
    private var _mode:String;
    private var _progress:Number;
    
    public function TransitionManager() {
        // Create high depth overlay
    }

    public static function getInstance():TransitionManager {
        if (_instance == null) {
            _instance = new TransitionManager();
        }
        return _instance;
    }
    
    // mode: "fade", "pixelate"
    public function startTransition(mode:String, duration:Number, onComplete:Function):Void {
        _mode = mode;
        _onComplete = onComplete;
        _progress = 0;
        
        createOverlay();
        
        var scope:TransitionManager = this;
        _overlay.onEnterFrame = function() {
            scope._progress += (1.0 / (duration * 30)); // assumes 30 fps
            if (scope._progress >= 1) {
                scope._progress = 1;
                scope.renderEffect();
                scope.complete();
            } else {
                scope.renderEffect();
            }
        };
    }
    
    private function createOverlay():Void {
        if (!_overlay) {
             _overlay = _root.createEmptyMovieClip("trans_overlay_mc", 999900);
        }
        _overlay._visible = true;
    }
    
    private function renderEffect():Void {
        _overlay.clear();
        _overlay.beginFill(0x000000, _progress * 100);
        _overlay.moveTo(0,0);
        _overlay.lineTo(Stage.width, 0);
        _overlay.lineTo(Stage.width, Stage.height);
        _overlay.lineTo(0, Stage.height);
        _overlay.endFill();
    }
    
    private function complete():Void {
        delete _overlay.onEnterFrame;
        // Optionally keep black until manual 'in' transition?
        // For now, auto fade out or just callback.
        if (_onComplete) {
            _onComplete();
        }
        
        // Auto reverse for "Fade In" effect usually handled by caller or state change logic.
        // Quick Fade Out logic:
        var scope:TransitionManager = this;
        _overlay.onEnterFrame = function() {
            scope._progress -= 0.05;
            if (scope._progress <= 0) {
                 delete scope._overlay.onEnterFrame;
                 scope._overlay._visible = false;
            }
            scope.renderEffect();
        };
    }
}
