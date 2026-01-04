/**
 * IScreen.as
 * Interface for all game screens.
 */
 
interface tr.flashocal.core.IScreen {
    function onEnter():Void;
    function onExit():Void;
    function update(dt:Number):Void;
    function getView():MovieClip;
}
