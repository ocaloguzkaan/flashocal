import tr.flashocal.core.Engine;

class tr.flashocal.debug.Stats {
    
    // Simple Stats Graph
    private var _view:MovieClip;
    private var _txt:TextField;
    
    private var _lastTime:Number;
    private var _frameCount:Number;
    private var _fps:Number;
    private var _mem:Number; // AS2 doesn't have System.totalMemory efficiently (only avail in newer player/AS3 usually). 
                             // Wait, System.totalMemory IS available in Flash Player 9+ (AS2 mode if compatible).
                             // We will try System['totalMemory'] or fallback.
                             
    public function Stats(target:MovieClip, x:Number, y:Number) {
        _view = target.createEmptyMovieClip("stats_mc", target.getNextHighestDepth());
        _view._x = x;
        _view._y = y;
        
        _view.beginFill(0x000033, 80);
        _view.drawRect(0, 0, 70, 50);
        _view.endFill();
        
        _view.createTextField("tf", 1, 2, 2, 65, 45);
        _txt = _view.tf;
        _txt.selectable = false;
        
        var fmt:TextFormat = new TextFormat();
        fmt.font = "_sans";
        fmt.size = 10;
        fmt.color = 0x00FFFF;
        _txt.setNewTextFormat(fmt);
        
        _lastTime = getTimer();
        _frameCount = 0;
        
        // Use an interval or Engine hook
        var scope:Object = this;
        _view.onEnterFrame = function() {
            scope.update();
        };
    }
    
    public function update():Void {
        _frameCount++;
        var t:Number = getTimer();
        
        if (t - _lastTime >= 1000) {
            _fps = _frameCount;
            _frameCount = 0;
            _lastTime = t;
            
            // Try get memory (naive check)
            var memVal:String = "-";
            if (_root.System && _root.System.totalMemory) {
                 memVal = Math.round(_root.System.totalMemory / 1024 / 1024) + "MB";
            }
            
            _txt.text = "FPS: " + _fps + "\nMEM: " + memVal;
        }
    }
}
