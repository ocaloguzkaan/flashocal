class tr.flashocal.net.PacketSerializer {
    
    // Simple JSON-like serializer since AS2 has no native JSON
    public static function serialize(data:Object):String {
        return packetObject(data);
    }
    
    private static function packetObject(obj:Object):String {
        var params:Array = new Array();
        for (var k:String in obj) {
            var val:Object = obj[k];
            var valStr:String = "";
            if (typeof(val) == "string") {
                valStr = "\"" + val + "\"";
            } else if (typeof(val) == "object" && !(val instanceof Array)) {
                valStr = packetObject(val);
            } else {
                valStr = String(val);
            }
            params.push("\"" + k + "\":" + valStr);
        }
        return "{" + params.join(",") + "}";
    }
    
    public static function interpolate(val1:Number, val2:Number, t:Number):Number {
        // Linear Interpolation for Network State
        return val1 + (val2 - val1) * t;
    }
}
