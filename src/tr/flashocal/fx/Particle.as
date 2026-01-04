class tr.flashocal.fx.Particle extends MovieClip {
    public var vx:Number;
    public var vy:Number;
    public var life:Number;
    public var maxLife:Number;
    public var active:Boolean;

    public function Particle() {
        vx = 0;
        vy = 0;
        life = 0;
        maxLife = 0;
        active = false;
    }

    public function init(x:Number, y:Number, life:Number):Void {
        this._x = x;
        this._y = y;
        this.life = life;
        this.maxLife = life;
        this.active = true;
        this._alpha = 100;
        this._xscale = 100;
        this._yscale = 100;
    }

    public function update():Boolean {
        if (!active) return false;
        
        this._x += vx;
        this._y += vy;
        this.life--;
        
        this._alpha = (life / maxLife) * 100;

        if (life <= 0) {
            active = false;
            this.removeMovieClip();
            return false;
        }
        return true;
    }
}
