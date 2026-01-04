import tr.flashocal.utils.Logger;
import tr.flashocal.testing.Assert;

class tr.flashocal.testing.TestRunner {
    
    private var _tests:Array;
    
    public function TestRunner() {
        _tests = new Array();
    }
    
    public function addTest(testFn:Function, scope:Object):Void {
        _tests.push({fn: testFn, sc: scope});
    }
    
    public function runAll():Void {
        Logger.log("=== STARTING UNIT TESTS ===");
        var passed:Number = 0;
        var failed:Number = 0;
        
        for (var i:Number = 0; i < _tests.length; i++) {
            var t:Object = _tests[i];
            try {
                t.fn.apply(t.sc);
                passed++;
            } catch (e:Object) {
                // In AS2 try-catch works in newer players.
                failed++;
                Logger.log("[TEST FAILED] " + e.toString());
            }
        }
        
        Logger.log("Results: " + passed + " Passed, " + failed + " Failed.");
        Logger.log("=== END TESTS ===");
    }
}
