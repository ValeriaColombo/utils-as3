package vale.utils.localization_old
{
	// ========================================================================
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	// ========================================================================

	/**
	 * Para la utilizacion de esta clase, deben existir: localization/texts.xml, localization/fonts.xml and localization/custom.xml
	 * Siempre inicializar esta clase y la clase Fonts antes de empeza a utilizarlas
	 **/
	public class MultiLanguageAsigner extends EventDispatcher
	{
		// ====================================================================
		public static const ON_DATA_LOADED : String = "data_loaded";

		private static var XmlTexts  : XML;
		private static var XmlFonts : XML;
		private static var XmlCustom : XML;
		// ====================================================================
		
		// --------------------------------------------------------------------
		public function MultiLanguageAsigner()
		{
			var loader1:URLLoader = new URLLoader();
			loader1.addEventListener(Event.COMPLETE, completeHandlerTexts);
			var req1:URLRequest = new URLRequest("localization/texts.xml");
			loader1.load(req1);
			
			var loader2:URLLoader = new URLLoader();
			loader2.addEventListener(Event.COMPLETE, completeHandlerFonts);
			var req2:URLRequest = new URLRequest("localization/fonts.xml");
			loader2.load(req2);

			var loader3:URLLoader = new URLLoader();
			loader3.addEventListener(Event.COMPLETE, completeHandlerVariables);
			var req3:URLRequest = new URLRequest("localization/custom.xml");
			loader3.load(req3);
		}
		
		// --------------------------------------------------------------------
		private function completeHandlerTexts(event:Event)
		{
			var loader:URLLoader = event.target as URLLoader;
			XmlTexts = new XML(loader.data);
			
			if(XmlFonts != null && XmlTexts != null && XmlCustom != null)
				dispatchEvent(new Event(ON_DATA_LOADED));
		}

		// --------------------------------------------------------------------
		private function completeHandlerFonts(event:Event)
		{
			var loader:URLLoader = event.target as URLLoader;
			XmlFonts = new XML(loader.data);
		
			if(XmlFonts != null && XmlTexts != null && XmlCustom != null)
				dispatchEvent(new Event(ON_DATA_LOADED));
		}
		
		// --------------------------------------------------------------------
		private function completeHandlerVariables(event:Event)
		{
			var loader:URLLoader = event.target as URLLoader;
			XmlCustom = new XML(loader.data);
			
			if(XmlFonts != null && XmlTexts != null && XmlCustom != null)
				dispatchEvent(new Event(ON_DATA_LOADED));
		}

		// --------------------------------------------------------------------
		public static function AsignText(campo : TextField)
		{
			var tipo : String = TypeName(campo.text);
			var nombre_campo : String = "@"+FieldName(campo.text);

			FormatText(campo, String(XmlFonts[tipo][0][nombre_campo]).split("_"), tipo);
			
			campo.text = String(XmlTexts[tipo][0][nombre_campo]);
		}

		// --------------------------------------------------------------------
		private static function FormatText(tf : TextField, format_data : Array, type : String)
		{ 
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = format_data[0];
			myFormat.align = format_data[1];
			myFormat.font = Fonts.Instance.FontNamed(format_data[2]).fontName;
			
			tf.defaultTextFormat = myFormat;
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.width = format_data[3];
			
			var parent = tf.parent;
			if(type == TextType.PLACA)
			{
				BackgroundWidthConfiguration(parent.fondo, format_data[3]);
			}
			else if(type ==  TextType.BOTON)
			{
				BackgroundWidthConfiguration(parent.fondoClick, format_data[3]);
				BackgroundWidthConfiguration(parent.fondoOver, format_data[3]);
				BackgroundWidthConfiguration(parent.fondoClickeable, format_data[3]);
				BackgroundWidthConfiguration(parent.fondo_noClickeable, format_data[3]);
			}
		}

		// --------------------------------------------------------------------
		private static function BackgroundWidthConfiguration(mc : MovieClip, nuevo_ancho)
		{
			if(mc!= null)
			{
				var ancho_anterior = mc.centro.width;
				mc.centro.width = nuevo_ancho;
				mc.bordeR.x -= ancho_anterior - nuevo_ancho;
			}
		}
		
		// --------------------------------------------------------------------
		private static function TypeName(texto_campo : String) : String
		{
			var nombres : Array = texto_campo.split("_");
			switch(nombres[1])
			{
				case "Plc":
					return TextType.PLACA;
				case "Btn":
					return TextType.BOTON;
				default:
					throw new Error("No existe un tipo de campo llamado " + nombres[1]);
			}
		}
		
		// --------------------------------------------------------------------
		private static function FieldName(field_text : String) : String
		{
			var names : Array = field_text.split("_");
			var field : String = names[2];
			field = field.replace("\r", "");
			
			return field;
		}
		
		// --------------------------------------------------------------------
		public static function CutomTextOf(name : String)
		{
			var field_name : String = "@"+name;
			return String(XmlCustom.TEXTO[0][field_name]);
		}
	}
}