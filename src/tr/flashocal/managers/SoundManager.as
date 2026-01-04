/**
 * SoundManager.as
 * Singleton for managing global sound.
 */

class tr.flashocal.managers.SoundManager {
    
    private static var _instance:SoundManager;
    private var _globalSound:Sound; // Used for global volume
    private var _sounds:Object;
    
    private function SoundManager() {
        _sounds = new Object();
        // Create a root sound object to control global volume
        var rootClip:MovieClip = _root.createEmptyMovieClip("snd_mgr_mc", _root.getNextHighestDepth());
        _globalSound = new Sound(rootClip);
    }
    
    public static function getInstance():SoundManager {
        if (_instance == null) {
            _instance = new SoundManager();
        }
        return _instance;
    }
    
    public function playSound(linkageID:String, volume:Number):Void {
        // Create temporary sound object
        // NOTE: In a real heavy game, you'd pool these or manage channels.
        var clipArgs:Object = { _x: 0, _y: 0 }; 
        // We attach audio to transient clips
        var sndClip:MovieClip = _root.createEmptyMovieClip("snd_" + linkageID + "_" + getTimer(), _root.getNextHighestDepth());
        var snd:Sound = new Sound(sndClip);
        snd.attachSound(linkageID);
        snd.setVolume(volume == undefined ? 100 : volume);
        snd.start();
        
        snd.onSoundComplete = function() {
            sndClip.removeMovieClip();
        };
    }
    
    public function setGlobalVolume(vol:Number):Void {
        _globalSound.setVolume(vol);
    }
}
