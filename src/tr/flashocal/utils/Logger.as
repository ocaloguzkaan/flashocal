/**
 * Logger.as
 * simple static logging utility.
 */

import tr.flashocal.debug.Console;

class tr.flashocal.utils.Logger {
    
    public static var debugMode:Boolean = true;
    
    public static function log(msg:Object):Void {
        if (debugMode) {
            var str:String = "[FlashOcal] " + msg.toString();
            trace(str);
            Console.getInstance().log(str);
        }
    }
    
    public static function error(msg:Object):Void {
        trace("[ERROR] " + msg.toString());
    }
}
