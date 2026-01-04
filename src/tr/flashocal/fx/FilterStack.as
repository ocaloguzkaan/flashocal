import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.GlowFilter;

class tr.flashocal.fx.FilterStack {
    
    private var _target:MovieClip;
    private var _filters:Array; // Chain of filters
    
    // Stack states
    private var _blur:BlurFilter;
    private var _glow:GlowFilter;
    private var _color:ColorMatrixFilter;
    
    public function FilterStack(target:MovieClip) {
        _target = target;
        _filters = new Array();
    }
    
    public function setBlur(amount:Number):Void {
        if (amount > 0) {
            _blur = new BlurFilter(amount, amount, 1);
        } else {
            _blur = null;
        }
        apply();
    }
    
    public function setNight(active:Boolean):Void {
        if (active) {
            var matrix:Array = [
                0.5, 0, 0, 0, -50,
                0, 0.5, 0, 0, -50,
                0, 0, 0.8, 0, -20,
                0, 0, 0, 1, 0
            ];
            _color = new ColorMatrixFilter(matrix);
        } else {
            _color = null;
        }
        apply();
    }
    
    public function setBoostGlow(active:Boolean):Void {
        if (active) {
            _glow = new GlowFilter(0x00FFFF, 1, 20, 20, 2, 2);
        } else {
            _glow = null;
        }
        apply();
    }
    
    private function apply():Void {
        var arr:Array = new Array();
        
        // Order matters for visuals, usually Color -> Blur -> Glow
        if (_color) arr.push(_color);
        if (_blur) arr.push(_blur);
        if (_glow) arr.push(_glow);
        
        _target.filters = arr;
    }
}
