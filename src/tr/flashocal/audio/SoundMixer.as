class tr.flashocal.audio.SoundMixer {
    
    private static var _instance:SoundMixer;
    private var _sounds:Object;
    private var _globalVolume:Number;
    
    // Internal generic Sound object for controlling global vol
    private var _globalSound:Sound;

    private function SoundMixer() {
        _sounds = new Object();
        _globalVolume = 100;
        _globalSound = new Sound();
    }
    
    public static function getInstance():SoundMixer {
        if (_instance == null) {
            _instance = new SoundMixer();
        }
        return _instance;
    }

    public function playSound(id:String, linkageId:String, loop:Boolean):Void {
        var s:Sound = new Sound();
        s.attachSound(linkageId);
        s.start(0, loop ? 999 : 0);
        _sounds[id] = s;
    }
    
    public function stopSound(id:String):Void {
        var s:Sound = _sounds[id];
        if (s) {
            s.stop();
        }
    }
    
    public function setGlobalVolume(vol:Number):Void {
        _globalVolume = vol;
        _globalSound.setVolume(vol);
    }
    
    // Simple 2D panning
    // -100 left, 100 right
    public function updateSpatialSound(id:String, x:Number, screenWidth:Number):Void {
        var s:Sound = _sounds[id];
        if (!s) return;
        
        var half:Number = screenWidth / 2;
        var pan:Number = ((x - half) / half) * 100;
        
        if (pan < -100) pan = -100;
        if (pan > 100) pan = 100;
        
        s.setPan(pan);
    }
}
