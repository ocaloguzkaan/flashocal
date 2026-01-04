/**
 * BaseScreen.as
 * Abstract implementation of a screen.
 */
 
import tr.flashocal.core.IScreen;

class tr.flashocal.objects.BaseScreen implements IScreen {
    
    private var _view:MovieClip;
    
    public function BaseScreen(view:MovieClip) {
        _view = view;
    }
    
    public function onEnter():Void {
        if (_view) _view._visible = true;
    }
    
    public function onExit():Void {
        if (_view) _view._visible = false;
    }
    
    public function update(dt:Number):Void {
        // Override me
    }
    
    public function getView():MovieClip {
        return _view;
    }
}
