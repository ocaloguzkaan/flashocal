import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import tr.flashocal.utils.Logger;

class tr.flashocal.utils.SnapshotTool {
    
    /**
     * Captures the target MovieClip as a BitmapData.
     * @param source The movieclip to capture.
     * @param w Width of capture.
     * @param h Height of capture.
     * @return BitmapData instance.
     */
    public static function capture(source:MovieClip, w:Number, h:Number):BitmapData {
        if (!source) return null;
        
        // Flash 8+ BitmapData
        var bmp:BitmapData = new BitmapData(w, h, true, 0x00000000);
        bmp.draw(source);
        
        return bmp;
    }
    
    /**
     * Encodes BitmapData to a simple string representation (e.g. for server upload).
     * AS2 doesn't have native PNG/JPG encoder built-in efficiently.
     * This is a placeholder for pixel dumping.
     */
    public static function dumpPixels(bmp:BitmapData):String {
        var w:Number = bmp.width;
        var h:Number = bmp.height;
        var s:String = "";
        
        // Very slow in AS2 for large images, essentially pseudo-code for the feature request
        // A real implementation would scan lines.
        s = "BMP:" + w + "x" + h + ":";
        // for (var y... for var x... getPixel32...)
        
        Logger.log("[SnapshotTool] Captured " + w + "x" + h);
        return s;
    }
}
