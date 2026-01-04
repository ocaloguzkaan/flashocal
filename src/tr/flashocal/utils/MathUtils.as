/**
 * MathUtils.as
 * Static class for math helper functions.
 */

class tr.flashocal.utils.MathUtils {

    /**
     * Returns a number between min and max (inclusive).
     */
    public static function randomRange(min:Number, max:Number):Number {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
    
    /**
     * Clamps a value between min and max.
     */
    public static function clamp(value:Number, min:Number, max:Number):Number {
        if (value < min) return min;
        if (value > max) return max;
        return value;
    }
    
    /**
     * Converts radians to degrees.
     */
    public static function toDegrees(rad:Number):Number {
        return rad * 180 / Math.PI;
    }
    
    /**
     * Converts degrees to radians.
     */
    public static function toRadians(deg:Number):Number {
        return deg * Math.PI / 180;
    }
    
    public static function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
        var dx:Number = x2 - x1;
        var dy:Number = y2 - y1;
        return Math.sqrt(dx * dx + dy * dy);
    }
}
