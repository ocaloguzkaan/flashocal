/**
 * Console.as
 * In-game debug console.
 */
 
import tr.flashocal.managers.InputManager;
import tr.flashocal.core.Engine;

class tr.flashocal.debug.Console {
    
    private static var _instance:Console;
    private var _view:MovieClip;
    private var _txt:TextField;
    private var _inTxt:TextField;
    private var _lines:Array;
    private var _visible:Boolean;
    
    private var _commands:Object;
    
    private function Console() {
        _lines = new Array();
        _commands = new Object();
        _visible = false;
        createView();
        
        registerCommand("help", this, cmdHelp);
        registerCommand("clear", this, cmdClear);
    }
    
    public static function getInstance():Console {
        if (_instance == null) {
            _instance = new Console();
        }
        return _instance;
    }
    
    private function createView():Void {
        // Create a movieclip on top depth
        var root:MovieClip = _root; // or Engine.getInstance()._root if accessible
        // We assume _root is global.
        
        _view = _root.createEmptyMovieClip("debug_console_mc", 999999);
        _view._visible = false;
        
        // Draw background
        _view.beginFill(0x000000, 80);
        _view.moveTo(0,0);
        _view.lineTo(Stage.width, 0);
        _view.lineTo(Stage.width, 200);
        _view.lineTo(0, 200);
        _view.lineTo(0, 0);
        _view.endFill();
        
        _view.createTextField("out_txt", 1, 5, 5, Stage.width - 10, 190);
        _txt = _view.out_txt;
        _txt.multiline = true;
        _txt.wordWrap = true;
        
        var fmt:TextFormat = new TextFormat();
        fmt.font = "_sans";
        fmt.size = 12;
        fmt.color = 0xFFFFFF;
        _txt.setNewTextFormat(fmt);
        
        // Input field for commands
        _view.createTextField("in_txt", 2, 5, 205, Stage.width - 10, 20);
        _inTxt = _view.in_txt;
        _inTxt.type = "input";
        _inTxt.border = true;
        _inTxt.borderColor = 0x666666;
        _inTxt.background = true;
        _inTxt.backgroundColor = 0x000000;
        _inTxt.textColor = 0x00FF00;
        _inTxt.setNewTextFormat(fmt);
        
        var scope:Console = this;
        // Key listener for Enter
        var kL:Object = new Object();
        kL.onKeyDown = function() {
            if (Key.getCode() == 13 && Selection.getFocus() == String(scope._inTxt)) {
                 scope.runCommand(scope._inTxt.text);
                 scope._inTxt.text = "";
            }
        };
        Key.addListener(kL);
    }
    
    // Command Logic
    public function registerCommand(name:String, scope:Object, callback:Function):Void {
        _commands[name] = {fn: callback, sc: scope};
    }
    
    public function runCommand(cmdLine:String):Void {
        log("> " + cmdLine);
        var parts:Array = cmdLine.split(" ");
        var cmd:String = String(parts.shift());
        
        if (_commands[cmd]) {
            var item:Object = _commands[cmd];
            item.fn.apply(item.sc, parts);
        } else {
            log("Unknown command: " + cmd);
        }
    }
    
    private function cmdHelp():Void {
        log("Available commands:");
        for (var k:String in _commands) {
            log(" - " + k);
        }
    }
    
    private function cmdClear():Void {
        _lines = new Array();
        refresh();
    }
    
    public function log(msg:Object):Void {
        _lines.push(msg.toString());
        if (_lines.length > 50) {
            _lines.shift();
        }
        refresh();
    }
    
    private function refresh():Void {
        if (!_view) return;
        _txt.text = _lines.join("\n");
        _txt.scroll = _txt.maxscroll;
    }
    
    public function toggle():Void {
        _visible = !_visible;
        _view._visible = _visible;
    }
    
    public function show():Void {
        _visible = true;
        _view._visible = true;
    }
    
    public function hide():Void {
        _visible = false;
        _view._visible = false;
    }
}
