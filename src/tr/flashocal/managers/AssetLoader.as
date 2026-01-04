/**
 * AssetLoader.as
 * Handles loading external resources (SWF, JPG, XML).
 */

import tr.flashocal.events.EventDispatcher;
import tr.flashocal.events.Event;

class tr.flashocal.managers.AssetLoader extends EventDispatcher {
    
    private var _mcLoader:MovieClipLoader;
    private var _listener:Object;
    private var _queue:Array;
    private var _currentLoad:Object;
    private var _isLoading:Boolean;
    
    public static var COMPLETE:String = "complete";
    public static var PROGRESS:String = "progress";
    public static var ITEM_COMPLETE:String = "itemComplete";
    public static var ERROR:String = "error";
    
    public function AssetLoader() {
        super();
        _queue = new Array();
        _isLoading = false;
        
        _mcLoader = new MovieClipLoader();
        _listener = new Object();
        
        var scope:AssetLoader = this;
        
        _listener.onLoadInit = function(target:MovieClip) {
            scope.onItemInit(target);
        };
        
        _listener.onLoadProgress = function(target:MovieClip, loaded:Number, total:Number) {
            scope.onItemProgress(target, loaded, total);
        };
        
        _listener.onLoadError = function(target:MovieClip, errorCode:String) {
             scope.onItemError(target, errorCode);
        };
        
        _mcLoader.addListener(_listener);
    }
    
    /**
     * Add an item to the load queue.
     * @param url Link to the asset.
     * @param container MovieClip to load into.
     * @param id Optional identifier.
     */
    public function addToQueue(url:String, container:MovieClip, id:String):Void {
        _queue.push({url: url, container: container, id: id});
    }
    
    public function start():Void {
        if (_isLoading) return;
        processQueue();
    }
    
    private function processQueue():Void {
        if (_queue.length == 0) {
            _isLoading = false;
            dispatchEvent(new Event(AssetLoader.COMPLETE, {}));
            return;
        }
        
        _isLoading = true;
        _currentLoad = _queue.shift();
        
        // If it looks like XML/Text, adapt usage (skipping XMLLoader for brevity, focusing on MCL)
        // For now, strict MovieClip/Image loading
        _mcLoader.loadClip(_currentLoad.url, _currentLoad.container);
    }
    
    private function onItemInit(target:MovieClip):Void {
        dispatchEvent(new Event(AssetLoader.ITEM_COMPLETE, { id: _currentLoad.id, target: target }));
        processQueue();
    }
    
    private function onItemProgress(target:MovieClip, loaded:Number, total:Number):Void {
        var percent:Number = Math.floor((loaded / total) * 100);
        dispatchEvent(new Event(AssetLoader.PROGRESS, { percent: percent, id: _currentLoad.id }));
    }
    
    private function onItemError(target:MovieClip, code:String):Void {
        dispatchEvent(new Event(AssetLoader.ERROR, { id: _currentLoad.id, code: code }));
        processQueue(); // Continue anyway?
    }
}
