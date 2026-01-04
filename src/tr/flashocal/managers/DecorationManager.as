import tr.flashocal.utils.Logger;
import tr.flashocal.render.Camera;

class tr.flashocal.managers.DecorationManager {
    
    private var _container:MovieClip;
    private var _activeDecorations:Array;
    private var _pool:Array; // Simple object pool since removing/attaching is expensive
    private var _camera:Camera; // Reference to camera for culling
    
    // Spawning parameters
    private var _spawnInterval:Number;
    private var _counter:Number;

    public function DecorationManager(container:MovieClip, camera:Camera) {
        _container = container;
        _camera = camera;
        _activeDecorations = new Array();
        _pool = new Array();
        _spawnInterval = 20; // Frames
        _counter = 0;
    }

    public function update(speed:Number):Void {
        // Move existing decorations relative to speed (simplified Z-movement logic for pseudo-3D)
        // or just lateral culling if 2D. 
        // Assuming a pseudo-3D racer context where objects come towards screen or pass by.
        
        for (var i:Number = _activeDecorations.length - 1; i >= 0; i--) {
            var deco:MovieClip = _activeDecorations[i];
            
            // Example logic: Move down/out to simulate passing
            // Real logic depends on if this is Outrun style (Z-scaling) or Top Down.
            // Assuming Top Down/Side Scroller based on previous 2D physics prompt, 
            // BUT user said "Camera3D" and "Level system (curves)" which implies Outrun.
            // Let's implement a generic culler that removes if off-screen.
            
            if (isOffScreen(deco)) {
                recycle(deco);
                _activeDecorations.splice(i, 1);
            }
        }
    }
    
    public function spawnDecoration(type:String, x:Number, y:Number, scale:Number):MovieClip {
        var deco:MovieClip = getFromPool(type);
        deco._x = x;
        deco._y = y;
        deco._xscale = deco._yscale = (scale != undefined) ? scale : 100;
        deco._visible = true;
        
        _activeDecorations.push(deco);
        return deco;
    }
    
    private function isOffScreen(mc:MovieClip):Boolean {
        // Simple check relative to Stage or Container
        // Adjust bounds as needed
        var b:Object = mc.getBounds(_root);
        if (b.xMax < 0 || b.xMin > Stage.width || b.yMax < 0 || b.yMin > Stage.height) {
            return true;
        }
        return false;
    }
    
    private function getFromPool(type:String):MovieClip {
        if (_pool.length > 0) {
            return _pool.pop();
        }
        // Create new
        var d:Number = _container.getNextHighestDepth();
        var name:String = "deco_" + d;
        // _container.attachMovie(type, name, d); 
        // Since we don't have linkage, create procedural empty
        _container.createEmptyMovieClip(name, d);
        var mc:MovieClip = _container[name];
        
        // Draw placeholder tree
        mc.lineStyle(2, 0x00FF00);
        mc.beginFill(0x00CC00);
        mc.moveTo(0, -20);
        mc.lineTo(10, 0);
        mc.lineTo(-10, 0);
        mc.endFill();
        mc.beginFill(0x8B4513);
        mc.drawRect(-2, 0, 4, 10);
        mc.endFill();
        
        return mc;
    }
    
    private function recycle(mc:MovieClip):Void {
        mc._visible = false;
        _pool.push(mc);
    }
}
