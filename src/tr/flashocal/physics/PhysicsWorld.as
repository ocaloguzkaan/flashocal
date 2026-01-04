import tr.flashocal.physics.RigidBody;

class tr.flashocal.physics.PhysicsWorld {
    
    private var _bodies:Array;
    public var gravityX:Number;
    public var gravity_Y:Number; // gravityY is a reserved word sometimes or confusing

    public function PhysicsWorld() {
        _bodies = new Array();
        gravityX = 0;
        gravity_Y = 0.5;
    }
    
    public function addBody(body:RigidBody):Void {
        _bodies.push(body);
    }
    
    public function removeBody(body:RigidBody):Void {
        // Find and splice
        for (var i:Number = 0; i < _bodies.length; i++) {
            if (_bodies[i] == body) {
                _bodies.splice(i, 1);
                break;
            }
        }
    }

    public function update():Void {
        // Step 1: Apply Forces (Gravity) and Integrate Velocity
        for (var i:Number = 0; i < _bodies.length; i++) {
            var b:RigidBody = _bodies[i];
            if (b.isStatic) continue;
            
            b.vx += gravityX;
            b.vy += gravity_Y;
            
            b.x += b.vx;
            b.y += b.vy;
            
            // Apply friction (simple damping)
            b.vx *= b.friction;
            b.vy *= b.friction;
        }
        
        // Step 2: Resolve Collisions (Circle/AABB simplified)
        // O(N^2) - warning for performance
        for (var i:Number = 0; i < _bodies.length; i++) {
            var b1:RigidBody = _bodies[i];
            for (var j:Number = i + 1; j < _bodies.length; j++) {
                var b2:RigidBody = _bodies[j];
                resolveCollision(b1, b2);
            }
        }
        
        // Step 3: Update Views
        for (var i:Number = 0; i < _bodies.length; i++) {
            _bodies[i].updateView();
        }
    }
    
    private function resolveCollision(b1:RigidBody, b2:RigidBody):Void {
        // Simple AABB vs AABB
        // Assuming center origins for simplicity of this skeleton
        var dx:Number = b1.x - b2.x;
        var dy:Number = b1.y - b2.y;
        
        var combinedHalfWidth:Number = (b1.width/2) + (b2.width/2);
        var combinedHalfHeight:Number = (b1.height/2) + (b2.height/2);
        
        if (Math.abs(dx) < combinedHalfWidth && Math.abs(dy) < combinedHalfHeight) {
            // Collision detected
            
            // Resolve overlap (very basic)
            var overlapX:Number = combinedHalfWidth - Math.abs(dx);
            var overlapY:Number = combinedHalfHeight - Math.abs(dy);
            
            if (overlapX < overlapY) {
                // Resolve X
                if (dx > 0) {
                     if (!b1.isStatic) b1.x += overlapX * 0.5;
                     if (!b2.isStatic) b2.x -= overlapX * 0.5;
                } else {
                     if (!b1.isStatic) b1.x -= overlapX * 0.5;
                     if (!b2.isStatic) b2.x += overlapX * 0.5;
                }
                
                // Bounce X
               var vRelX:Number = b1.vx - b2.vx;
               b1.vx = -b1.vx * b1.restitution;
               b2.vx = -b2.vx * b2.restitution;
               
            } else {
                // Resolve Y
                if (dy > 0) {
                     if (!b1.isStatic) b1.y += overlapY * 0.5;
                     if (!b2.isStatic) b2.y -= overlapY * 0.5;
                } else {
                     if (!b1.isStatic) b1.y -= overlapY * 0.5;
                     if (!b2.isStatic) b2.y += overlapY * 0.5;
                }
                
               // Bounce Y
               b1.vy = -b1.vy * b1.restitution;
               b2.vy = -b2.vy * b2.restitution;
            }
        }
    }
}
