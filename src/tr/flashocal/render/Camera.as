class tr.flashocal.render.Camera {
    private var _container:MovieClip;
    private var _target:MovieClip;
    
    private var _shakeIntensity:Number = 0;
    private var _shakeDecay:Number = 0;
    
    // Zoom/Scale
    private var _zoom:Number = 1.0;
    // Zoom/Scale
    private var _zoom:Number = 1.0;
    private var _targetZoom:Number = 1.0;
    
    // Rotation/Lean
    private var _rotation:Number = 0;
    private var _targetRotation:Number = 0;
    
    public var leanSpeed:Number = 0.1;
    
    public var followSpeed:Number;
    
    public function Camera(container:MovieClip) {
        _container = container;
        _zoom = 1.0;
        _targetZoom = 1.0;
        followSpeed = 0.1;
    }

    public function follow(target:MovieClip):Void {
        _target = target;
    }

    public function shake(intensity:Number, durationSeconds:Number):Void {
        _shakeIntensity = intensity;
        _shakeDecay = intensity / (durationSeconds * 30); // Assuming 30 FPS
    }

    public function setZoom(value:Number):Void {
        _targetZoom = value;
    }
    
    public function lean(angle:Number):Void {
        _targetRotation = angle;
    }

    public function update():Void {
        if (_target == null) return;

        // Target Follow Logic
        // Center the target on screen (assuming 800x600 resolution or using Stage)
        // In AS2, Stage.width/height might be global.
        
        var sw:Number = Stage.width; 
        var sh:Number = Stage.height;
        if (sw == undefined) sw = 800; // Fallback
        if (sh == undefined) sh = 600;

        var targetX:Number = -_target._x * _zoom + sw / 2;
        var targetY:Number = -_target._y * _zoom + sh / 2;

        _container._x += (targetX - _container._x) * followSpeed;
        _container._y += (targetY - _container._y) * followSpeed;

        // Zoom Logic
        _zoom += (_targetZoom - _zoom) * 0.1;
        _container._xscale = _container._yscale = _zoom * 100;
        
        // Lean/Rotation Logic
        _rotation += (_targetRotation - _rotation) * leanSpeed;
        _container._rotation = _rotation;

        // Shake Logic
        if (_shakeIntensity > 0) {
            var rx:Number = (Math.random() * _shakeIntensity * 2) - _shakeIntensity;
            var ry:Number = (Math.random() * _shakeIntensity * 2) - _shakeIntensity;
            
            _container._x += rx;
            _container._y += ry;
            
            _shakeIntensity -= _shakeDecay;
            if (_shakeIntensity < 0) _shakeIntensity = 0;
        }
    }
    
    public function lookAt(x:Number, y:Number):Void {
        var sw:Number = Stage.width;
        var sh:Number = Stage.height;
        if (sw == undefined) sw = 800;
        if (sh == undefined) sh = 600;
        
        _container._x = -x * _zoom + sw / 2;
        _container._y = -y * _zoom + sh / 2;
    }
}
