/**
 * Event.as
 * Base class for events.
 */

class tr.flashocal.events.Event {
    
    public var type:String;
    public var target:Object;
    public var data:Object;
    
    public function Event(type:String, data:Object) {
        this.type = type;
        this.data = data;
    }
}
