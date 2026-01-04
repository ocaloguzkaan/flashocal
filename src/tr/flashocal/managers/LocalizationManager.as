import tr.flashocal.utils.Logger;

class tr.flashocal.managers.LocalizationManager {

    private static var _instance:LocalizationManager;
    private var _dictionary:Object;
    private var _fonts:Object; // Map langCode -> FontName
    private var _currentLanguage:String;

    private function LocalizationManager() {
        _dictionary = new Object();
        _fonts = new Object();
            // defaults
        _fonts["en"] = "Arial"; 
        _fonts["tr"] = "Arial";
        _fonts["es"] = "Arial";
        _fonts["fr"] = "Arial";
        _fonts["de"] = "Arial";
        _fonts["it"] = "Arial";
        _fonts["pt"] = "Arial";
        _fonts["ru"] = "Arial";
        _fonts["ja"] = "_sans";
        _fonts["zh"] = "_sans";
        _fonts["ko"] = "_sans";
        
        _currentLanguage = "en"; // default
    }

    public static function getInstance():LocalizationManager {
        if (_instance == null) {
            _instance = new LocalizationManager();
        }
        return _instance;
    }

    /**
     * Loads language data from an Object (parsed XML/JSON).
     * Structure expected: { "en": { "KEY": "Value" }, "tr": { ... } }
     */
    public function loadLanguageData(data:Object, fontMap:Object):Void {
        _dictionary = data;
        if (fontMap) {
            for (var k:String in fontMap) {
                _fonts[k] = fontMap[k];
            }
        }
        Logger.log("[LocalizationManager] Data loaded.");
    }
    
    public function setLanguage(langCode:String):Void {
        if (_dictionary[langCode] != undefined) {
            _currentLanguage = langCode;
            Logger.log("[LocalizationManager] Language changed to: " + langCode);
            updateUI();
        } else {
            Logger.log("[LocalizationManager] Warning: Language " + langCode + " not found.");
        }
    }

    public function get(key:String):String {
        if (_dictionary[_currentLanguage] && _dictionary[_currentLanguage][key]) {
            return _dictionary[_currentLanguage][key];
        }
        return "[?" + key + "]";
    }
    
    public function getCurrentFont():String {
        return _fonts[_currentLanguage] ? _fonts[_currentLanguage] : "_sans";
    }
    
    // Can be called manually or auto-trigger event
    private function updateUI():Void {
        // In a real framework, this would dispatch "LANGUAGE_CHANGE" event
        // so all active UI components redraw themselves.
    }
}
