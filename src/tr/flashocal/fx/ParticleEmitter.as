import tr.flashocal.utils.ObjectPool;
import tr.flashocal.fx.Particle;

class tr.flashocal.fx.ParticleEmitter {
    private var _particles:Array;
    private var _container:MovieClip;
    private var _pool:ObjectPool;
    private var _depthCounter:Number;

    public function ParticleEmitter(container:MovieClip) {
        _container = container;
        _particles = new Array();
        _depthCounter = 0;
        
        // We can't really pool MovieClips cleanly in AS2 without attachMovie/dupMovie logic inside the pool or factory.
        // For this simplified logic, we'll manage creation manually or assume pool usage if configured.
    }

    public function emit(x:Number, y:Number, count:Number):Void {
        for (var i:Number = 0; i < count; i++) {
            spawnParticle(x, y);
        }
    }

    private function spawnParticle(x:Number, y:Number):Void {
        var d:Number = _container.getNextHighestDepth() + _depthCounter++; 
        // Note: getNextHighestDepth is AS2 but sometimes quirky.
        
        // In a real framework, we'd use attachMovie with a Linkage ID.
        // Since we don't have the linkage ID 'Particle' guaranteed, we might createEmptyMovieClip
        // but that won't have graphics. 
        // We will assume there is a linkage ID "ParticleBase" in the library that Particle class attaches to.
        // Or we draw procedurally.
        
        var pName:String = "p_" + d;
        // _container.attachMovie("ParticleSymbol", pName, d);
        // var p:Particle = _container[pName]; // In AS2 classes are not fully auto-linked always without Object.registerClass
        
        // Procedural fallback for "skeleton":
        _container.createEmptyMovieClip(pName, d);
        var pMc:MovieClip = _container[pName];
        
        // Simple graphics
        pMc.beginFill(0xFF0000, 100);
        pMc.moveTo(-2, -2);
        pMc.lineTo(2, -2);
        pMc.lineTo(2, 2);
        pMc.lineTo(-2, 2);
        pMc.endFill();
        
        // Decorate with Particle logic (mixin style since we created empty MC)
        // or Wrap it.
        // Since Particle extends MovieClip, we can't easily cast a created empty MC to it without registerClass 
        // or #initclip. 
        
        // Let's use a Wrapper approach for the Emitter to be safe in pure code.
        var pIdx:Number = _particles.length;
        var pObj:Object = {mc: pMc, vx: Math.random()*4-2, vy: Math.random()*4-2, life: 60, maxLife: 60};
        _particles.push(pObj);
        
        pMc._x = x;
        pMc._y = y;
    }

    public function update():Void {
        for (var i:Number = _particles.length - 1; i >= 0; i--) {
            var p:Object = _particles[i];
            
            p.mc._x += p.vx;
            p.mc._y += p.vy;
            p.life--;
            p.mc._alpha = (p.life / p.maxLife) * 100;
            
            if (p.life <= 0) {
                p.mc.removeMovieClip();
                _particles.splice(i, 1);
            }
        }
    }
}
