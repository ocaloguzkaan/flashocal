import flash.geom.Point;

class tr.flashocal.ai.WaypointPath {
    
    private var _points:Array;
    private var _isClosed:Boolean;
    
    public function WaypointPath() {
        _points = new Array();
        _isClosed = false;
    }
    
    public function addPoint(x:Number, y:Number):Void {
        _points.push({x: x, y: y});
    }
    
    public function setClosed(closed:Boolean):Void {
        _isClosed = closed;
    }
    
    // Simple Linear Interpolation
    public function getPointAt(t:Number):Object {
        // t is 0..1 across entire path? Or index?
        // Let's assume t is 0..points.length
        
        if (_points.length < 2) return _points[0];
        
        var p1Index:Number = Math.floor(t);
        var p2Index:Number = p1Index + 1;
        
        if (_isClosed) {
            p1Index %= _points.length;
            p2Index %= _points.length;
        } else {
            if (p2Index >= _points.length) {
                p1Index = _points.length - 2;
                p2Index = _points.length - 1;
            }
        }
        
        var localT:Number = t - Math.floor(t);
        
        var p1:Object = _points[p1Index];
        var p2:Object = _points[p2Index];
        
        return {
            x: p1.x + (p2.x - p1.x) * localT,
            y: p1.y + (p2.y - p1.y) * localT
        };
    }
    
    // Catmull-Rom Spline (Smooth)
    public function getSplinePoint(t:Number):Object {
        if (_points.length < 4 || !_isClosed) return getPointAt(t); 
        
        // Need 4 points: p0, p1, p2, p3 to interpolate between p1 and p2
        var i:Number = Math.floor(t);
        var p0:Object = _points[(i - 1 + _points.length) % _points.length];
        var p1:Object = _points[i % _points.length];
        var p2:Object = _points[(i + 1) % _points.length];
        var p3:Object = _points[(i + 2) % _points.length];
        
        var u:Number = t - i;
        var u2:Number = u * u;
        var u3:Number = u * u * u;
        
        // Catmull-Rom formula
        var fx:Number = 0.5 * ( (2*p1.x) + (-p0.x + p2.x)*u + (2*p0.x - 5*p1.x + 4*p2.x - p3.x)*u2 + (-p0.x + 3*p1.x - 3*p2.x + p3.x)*u3 );
        var fy:Number = 0.5 * ( (2*p1.y) + (-p0.y + p2.y)*u + (2*p0.y - 5*p1.y + 4*p2.y - p3.y)*u2 + (-p0.y + 3*p1.y - 3*p2.y + p3.y)*u3 );
        
        return {x: fx, y: fy};
    }
}
