import tr.flashocal.managers.InputManager;
import tr.flashocal.core.Engine;

class tr.flashocal.managers.ReplayManager {
    
    // Structure: Array of objects { t: timestamp, keyC: keyCode, d: down/up }
    // Or simplified: Array of [frameInputs]
    
    private var _recording:Array;
    private var _isRecording:Boolean;
    private var _isPlaying:Boolean;
    private var _playbackIndex:Number;
    
    // Ghost Target to apply inputs to
    private var _ghostTarget:Object; // e.g. NpcCar

    public function ReplayManager() {
        _recording = new Array();
        _isRecording = false;
        _isPlaying = false;
    }
    
    public function startRecording():Void {
        _recording = new Array();
        _isRecording = true;
        _isPlaying = false;
    }
    
    public function stopRecording():Void {
        _isRecording = false;
    }
    
    public function startPlayback(ghost:Object):Void {
        if (_recording.length == 0) return;
        _ghostTarget = ghost;
        _isPlaying = true;
        _isRecording = false;
        _playbackIndex = 0;
    }
    
    // Called every frame by Engine/GameLoop
    public function update():Void {
        if (_isRecording) {
            // Snapshot current input state
            // Assumes InputManager has a way to get 'current active keys' or we record specific relevant keys
            // For a car game: Left, Right, Up, Down, Handbrake
            // We'll store a bitmask or object.
            var inputSnapshot:Object = {
                u: Key.isDown(Key.UP),
                d: Key.isDown(Key.DOWN),
                l: Key.isDown(Key.LEFT),
                r: Key.isDown(Key.RIGHT)
            };
            _recording.push(inputSnapshot);
        }
        
        if (_isPlaying && _ghostTarget) {
            if (_playbackIndex < _recording.length) {
                var data:Object = _recording[_playbackIndex];
                
                // Apple data to ghost
                // Ghost must implement "setInput(u,d,l,r)" or similar
                if (_ghostTarget.setInputs) {
                    _ghostTarget.setInputs(data.u, data.d, data.l, data.r);
                }
                
                _playbackIndex++;
            } else {
                _isPlaying = false; // End provided
            }
        }
    }
    
    public function get recordingData():Array {
        return _recording;
    }
}
