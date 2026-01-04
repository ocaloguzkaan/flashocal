class tr.flashocal.render.DepthManager {
    
    // Sort an array of generic objects/MovieClips by 'y' property
    public static function simpleSort(displayObjects:Array):Void {
        displayObjects.sortOn("_y", Array.NUMERIC);
        
        // Apply depths based on sorted index
        // Note: Changing depth in Flash AS2 with swapDepths acts on the MovieClip
        // We need a base depth to start form.
        var baseDepth:Number = 1000;
        
        for (var i:Number = 0; i < displayObjects.length; i++) {
            var mc:MovieClip = displayObjects[i];
            if (mc.getDepth() != (baseDepth + i)) {
                mc.swapDepths(baseDepth + i);
            }
        }
    }
    
    // Culling helper
    public static function cull(displayObjects:Array, screenRect:Object):Array {
        var visibleList:Array = new Array();
        
        for (var i:Number = 0; i < displayObjects.length; i++) {
            var mc:MovieClip = displayObjects[i];
            
            // Simple bound check (assuming center registration or just x/y)
            if (mc._x > screenRect.xMin && mc._x < screenRect.xMax &&
                mc._y > screenRect.yMin && mc._y < screenRect.yMax) {
                mc._visible = true;
                visibleList.push(mc);
            } else {
                mc._visible = false;
            }
        }
        return visibleList;
    }
}
