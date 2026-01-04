/**
 * GameObject.as
 * Base class for all interactive objects in the game world.
 * Can be linked to a Library symbol via attachMovie or wrapping an existing clip.
 */

import tr.flashocal.utils.MathUtils;

class tr.flashocal.objects.GameObject {
    
    public var mc:MovieClip; // The visual representation
    public var x:Number;
    public var y:Number;
    public var velocityX:Number;
    public var velocityY:Number;
    public var active:Boolean;
    
    public function GameObject(targetMC:MovieClip) {
        mc = targetMC;
        x = mc._x;
        y = mc._y;
        velocityX = 0;
        velocityY = 0;
        active = true;
    }
    
    public function update(dt:Number):Void {
        if (!active) return;
        
        x += velocityX * dt;
        y += velocityY * dt;
        
        render();
    }
    
    public function render():Void {
        mc._x = x;
        mc._y = y;
    }
    
    public function setPosition(newX:Number, newY:Number):Void {
        x = newX;
        y = newY;
        render();
    }
    
    public function destroy():Void {
        mc.removeMovieClip();
        active = false;
    }
}
