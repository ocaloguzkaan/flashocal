class tr.flashocal.testing.Assert {
    public static function isTrue(val:Boolean, msg:String):Void {
        if (!val) {
            trace("[FAIL] " + msg);
            throw new Error(msg); // Error class in AS2? 'throw' is supported in later AS2 compilers.
            // If Flash 6, might just trace. Assuming Flash 8+.
        } else {
            // trace("[PASS] " + msg);
        }
    }
    
    public static function areEqual(curr:Object, expected:Object, msg:String):Void {
        if (curr != expected) {
            trace("[FAIL] " + msg + " Expected: " + expected + " Got: " + curr);
        }
    }
}
