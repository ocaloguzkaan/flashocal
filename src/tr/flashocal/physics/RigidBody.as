class tr.flashocal.physics.RigidBody {
    public var x:Number;
    public var y:Number;
    public var vx:Number;
    public var vy:Number;
    
    public var mass:Number;
    public var friction:Number;
    public var restitution:Number;
    public var isStatic:Boolean;
    
    public var width:Number;
    public var height:Number;
    
    // Linked display object
    public var view:MovieClip;

    public function RigidBody(view:MovieClip) {
        this.view = view;
        this.x = view._x;
        this.y = view._y;
        this.width = view._width;
        this.height = view._height;
        
        this.vx = 0;
        this.vy = 0;
        
        this.mass = 1.0;
        this.friction = 0.9; // 1.0 = no friction, 0.0 = stops instantly
        this.restitution = 0.5; // Bounciness
        this.isStatic = false;
    }
    
    public function updateView():Void {
        if (view) {
            view._x = x;
            view._y = y;
        }
    }
}
