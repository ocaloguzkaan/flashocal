import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.GlowFilter;

class tr.flashocal.fx.EffectManager {
    
    private var _target:MovieClip;
    
    public function EffectManager(target:MovieClip) {
        _target = target;
    }
    
    public function applySpeedBlur(amount:Number):Void {
        if (amount <= 0) {
             clearFilters();
             return;
        }
        var blur:BlurFilter = new BlurFilter(amount, amount, 1);
        _target.filters = [blur];
    }
    
    public function applyNightMode():Void {
        var matrix:Array = [
            0.3, 0, 0, 0, -50,
            0, 0.3, 0, 0, -50,
            0, 0, 0.5, 0, -50,
            0, 0, 0, 1, 0
        ];
        var cm:ColorMatrixFilter = new ColorMatrixFilter(matrix);
        // Append to existing or set new
        // For simplicity, overwrite
        _target.filters = [cm];
    }
    
    public function clearFilters():Void {
        _target.filters = [];
    }
}
