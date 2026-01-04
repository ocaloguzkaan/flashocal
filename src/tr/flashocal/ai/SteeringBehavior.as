import flash.geom.Point;
import tr.flashocal.utils.MathUtils;

class tr.flashocal.ai.SteeringBehavior {
    
    private var _host:Object; // The object being steered (must have x, y, vx, vy, maxSpeed)
    
    // Steering Outputs (could be forces or direct velocity changes)
    public var steeringX:Number;
    public var steeringY:Number;
    
    public function SteeringBehavior(host:Object) {
        _host = host;
        steeringX = 0;
        steeringY = 0;
    }
    
    public function seek(targetX:Number, targetY:Number):Void {
        var dx:Number = targetX - _host.x;
        var dy:Number = targetY - _host.y;
        
        // Normalize
        var dist:Number = Math.sqrt(dx*dx + dy*dy);
        if (dist > 0) {
            dx /= dist;
            dy /= dist;
            
            // Scaled to maxSpeed
            dx *= _host.maxSpeed;
            dy *= _host.maxSpeed;
            
            // Steering = Desired - Velocity
            steeringX += (dx - _host.vx);
            steeringY += (dy - _host.vy);
        }
    }
    
    public function avoid(obstacles:Array, warningDist:Number):Void {
        // Simple raycast or proximity check
        // Vector projected ahead
        var aheadX:Number = _host.x + _host.vx * 20; // 20 frames ahead? or normalized warningDist
        var aheadY:Number = _host.y + _host.vy * 20;
        
        var mostThreatening:Object = null;
        
        for (var i:Number = 0; i < obstacles.length; i++) {
            var obs:Object = obstacles[i];
            var d:Number = MathUtils.getDistance(_host.x, _host.y, obs.x, obs.y);
            
            // If close enough specifically in front?
            // Simplified: simple distance check for now
            if (d < warningDist) {
                 mostThreatening = obs;
                 break; // for now pick first
            }
        }
        
        if (mostThreatening != null) {
            // Steering force away from obstacle
            var avoidX:Number = aheadX - mostThreatening.x;
            var avoidY:Number = aheadY - mostThreatening.y;
            
            // Normalize
            var len:Number = Math.sqrt(avoidX*avoidX + avoidY*avoidY);
            if (len > 0) {
                 avoidX /= len;
                 avoidY /= len;
                 
                 avoidX *= _host.maxSpeed;
                 avoidY *= _host.maxSpeed;
                 
                 steeringX += avoidX;
                 steeringY += avoidY;
            }
        }
    }
    
    public function update():Void {
        // Truncate steering force and apply to host velocity (host handles mass?)
        // Or assume host reads steeringX/Y and applies it.
        // We just accumulate forces per frame, then reset.
    }
    
    public function reset():Void {
        steeringX = 0;
        steeringY = 0;
    }
}
