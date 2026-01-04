import tr.flashocal.utils.Logger;

class tr.flashocal.net.RemoteLogger {
    
    private var _endpoint:String;
    
    public function RemoteLogger(endpoint:String) {
        _endpoint = endpoint;
    }
    
    public function log(level:String, message:String, stackParams:Object):Void {
        var lv:LoadVars = new LoadVars();
        lv.level = level;
        lv.message = message;
        lv.timestamp = new Date().toString();
        
        if (stackParams) {
            for (var k:String in stackParams) {
                lv[k] = stackParams[k];
            }
        }
        
        lv.sendAndLoad(_endpoint, lv, "POST");
        // We generally fire and forget for logs, or handle onLoad if needed.
    }
    
    public function reportCrash(details:String):Void {
        log("CRASH", details, {urgent: true});
        Logger.log("[RemoteLogger] Crash report sent.");
    }
}
