package vale.utils.localization
{
	// ========================================================================
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	// ========================================================================

	/**
	 * Inicialization:
	 * 
	 * 		var texts : LocalizationManager = new LocalizationManager();
	 *		texts.addEventListener(LocalizationManager.ON_STRINGS_LOADED, OnStringsLoaded);
	 * 
	 * Use:
	 * 		LocalizationManager.AsignText(text_field);
	 * **/
	public class LocalizationManager extends EventDispatcher
	{
		// ====================================================================
		public static var ON_STRINGS_LOADED : String = "LocalizationManager_ON_STRINGS_LOADED";
		private static var XmlStrings  : XML;
		// ====================================================================

		// --------------------------------------------------------------------
		public function LocalizationManager()
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onStringsLoaderCompleteHandler);
			var req:URLRequest = new URLRequest("strings.xml");
			loader.load(req);
		}
		
		// --------------------------------------------------------------------
		private function onStringsLoaderCompleteHandler(event:Event)
		{
			var loader:URLLoader = event.target as URLLoader;
			XmlStrings = new XML(loader.data);
			dispatchEvent(new Event(ON_STRINGS_LOADED));
		}
		
		/**
		 * @return The value in strings.xml/strings/custom/text_name
		 **/
		// --------------------------------------------------------------------
		public static function GetCustomText(text_name : String) : String
		{
			return String(XmlStrings["custom"][text_name].@text);
		}
		
		/**
		 * Use:
		 * TextFields:
		 * 		LocalizationManager.AsignText(tf);
		 *		LocalizationManager.AsignText(tf, ["[FieldName1]_value1", "[FieldName2]_value2"]);
		 * 
		 * @param tf: TextField to complete. The property text must have the format: BTN_name or TF_name, 
		 * 		and in the strings.xml file there has to be a field: strings/graphics/TF_name or strings/graphics/BTN_name.
		 * 		To make the bkg change its width dynamicaly, the MovieClip that contains the TextField, 
		 * 		must have a child named Bkg if it is just a TestField, or BkgClick, BkgOver, BkgClickeable and/or BkgNoClickeable if it is a LocalizableButton.
		 * @param extra_params: "A_B" replaces A with B in the text assigned to tf.
		 * 
		 **/
		// --------------------------------------------------------------------
		public static function AsignText(tf : TextField, extra_params : Array = null)
		{
			var tf_name : String = tf.text.replace("\r", "");
			var type : String = TypeName(tf.text);

			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.autoSize = TextFieldAutoSize.CENTER;
			var input_text : String = String(XmlStrings["graphics"][tf_name].@text);
			tf.htmlText = input_text;
			
			var format : TextFormat = tf.getTextFormat();
			format.size = Number(XmlStrings["graphics"][tf_name].@fontSize);
			tf.setTextFormat(format);
			
			FormatText(tf, type);
			
			if(extra_params != null)
			{
				for each(var param : String in extra_params)
				{
					var split : Array = param.split("_");
					tf.text = tf.text.replace(split[0], split[1]);
				}
			}
		}
		
		// --------------------------------------------------------------------
		private static function FormatText(tf : TextField, type : String)
		{
			var parent = tf.parent;
			if(type == TextType.TEXT)
			{
				BackgroundWidthConfiguration(parent.Bkg, tf.width);
			}
			else if(type ==  TextType.BUTTON)
			{
				BackgroundWidthConfiguration(parent.BkgClick, tf.width);
				BackgroundWidthConfiguration(parent.BkgOver, tf.width);
				BackgroundWidthConfiguration(parent.BkgClickeable, tf.width);
				BackgroundWidthConfiguration(parent.BkgNoClickeable, tf.width);
			}
		}
		
		// --------------------------------------------------------------------
		private static function BackgroundWidthConfiguration(mc : MovieClip, new_width : Number)
		{
			if(mc!= null)
			{
				var old_width : Number = mc.mc_center.width;
				mc.mc_center.width = new_width;
				mc.mc_right.x -= old_width - new_width;
			}
		}
		
		// --------------------------------------------------------------------
		private static function TypeName(field_text : String) : String
		{
			var names : Array = field_text.split("_");
			switch(names[0])
			{
				case "TF":
					return TextType.TEXT;
				case "BTN":
					return TextType.BUTTON;
				default:
					throw new Error("There is no text type named " + names[1], 106);
			}
		}
	}
}