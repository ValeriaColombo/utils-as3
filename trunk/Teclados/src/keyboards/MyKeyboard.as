package keyboards
{
	// ========================================================================
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;

	// ========================================================================
	
	public class MyKeyboard extends Sprite
	{
		// ====================================================================
		public static var LANG_ESPANOL   : String = "ES";
		public static var LANG_ENGLISH   : String = "EN";
		public static var LANG_PORTUGUES : String = "PT";
		// ====================================================================
		public static var WRITE : String = "MyKeyboard_Write";
		public static var CHAR_KEY : String = "MyKeyboard_CharKey";
		public static var CONTROL_KEY : String = "MyKeyboard_ControlKey";
		public static var CLICK_ENTER : String = "MyKeyboard_ClickEnter";
		public static var CLICK_TAB   : String = "MyKeyboard_ClickTab";
		// ====================================================================
		private var uses_real_keyboard : Boolean;
		protected var mc_teclado : MovieClip;
		protected var lang : String;
		
		private var shift;
		
		private var text_field : TextField;
		private var max_chars : uint;
		private var min_width : Number;
		private var min_height : Number;
		private var allows_enter : Boolean;
		private var allows_tab : Boolean;
		// ====================================================================
		
		// --------------------------------------------------------------------
		public function MyKeyboard(_lang : String = "ES", _uses_real_keyboard : Boolean = true)
		{
			super();

			mc_teclado.tabChildren = false;
			mc_teclado.tabEnabled = false;
			
			mc_teclado.color_teclas.visible = false;
			mc_teclado.color_fondo.visible = false;
			
			lang = _lang;
			uses_real_keyboard = _uses_real_keyboard;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// --------------------------------------------------------------------
		public function ColorFondo(_color : uint, _alpha : Number = 1)
		{
			mc_teclado.color_fondo.visible = true;
			
			var colorTransform:ColorTransform = mc_teclado.color_fondo.transform.colorTransform;
			colorTransform.color = _color;
			mc_teclado.color_fondo.transform.colorTransform = colorTransform;
			mc_teclado.color_fondo.alpha = _alpha;
		}
		
		// --------------------------------------------------------------------
		public function ColorTeclas(_color : uint, _alpha : Number = 0.5)
		{
			mc_teclado.color_teclas.visible = true;
			
			var colorTransform:ColorTransform = mc_teclado.color_teclas.transform.colorTransform;
			colorTransform.color = _color;
			mc_teclado.color_teclas.transform.colorTransform = colorTransform;
			mc_teclado.color_teclas.alpha = _alpha;
		}
		
		// --------------------------------------------------------------------
		private function init(e:Event=null):void
		{
			trace("caca")
			if(e != null) removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if(uses_real_keyboard)
				mc_teclado.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			
			for (var i = 0; i < mc_teclado.numChildren; i++)
			{
				MovieClip(mc_teclado.getChildAt(i)).gotoAndStop(1);
				mc_teclado.getChildAt(i).addEventListener(MouseEvent.CLICK, clickTecla);
			}
		}
		
		// --------------------------------------------------------------------
		public function get TextFieldName() : String
		{
			if(text_field != null)
				return text_field.name;
			
			return "";
		}
		
		/**
		 *  Asigna el textfield a editar con el teclado.
		 * 
		 * @param _tf el Textfield asignado
		 * @param _max_chars
		 * @param _delete_field borrar o no el texto actual del textfield
		 * @param _allows_enter al apretar TAB, aparte de tirar el evento CLICK_ENTER, agrega una nueva linea al texto
		 * @param _allows_tab al apretar TAB, aparte de tirar el evento CLICK_TAB, agrega "    " al texto
		 **/
		// --------------------------------------------------------------------
		public function SetTextField(_tf:TextField, _max_chars : int = 100, _delete_field : Boolean = false, _allows_enter : Boolean = false, _allows_tab : Boolean = false)
		{
			text_field = _tf;
			max_chars = _max_chars;
			allows_enter = _allows_enter;
			allows_tab = _allows_tab;
			
			if(text_field != null)
			{
				min_height = text_field.height;
				min_width = text_field.width;
				
				text_field.maxChars = max_chars;
				text_field.autoSize = TextFieldAutoSize.LEFT;
			
				if(_delete_field)
				{
					text_field.text = "";
					text_field.width = min_width;
					text_field.height = min_height;
				}
			}
		}		
		
		// --------------------------------------------------------------------
		protected function onKeyboardDown(e:KeyboardEvent)
		{
			throw new Error("Must override");
		}
		
		var tt;
		// --------------------------------------------------------------------
		private function clickTecla(e:MouseEvent)
		{
			try
			{
				e.currentTarget.gotoAndStop("down");
				tt = e.currentTarget;
				setTimeout(UpTeclaCliqueada, 10);
			}
			catch(error){}
			
			ApretarTecla(e.currentTarget.name);
		}
		
		// --------------------------------------------------------------------
		private function UpTeclaCliqueada()
		{
			tt.gotoAndStop(1);
		}
		
		// --------------------------------------------------------------------
		protected function ApretarTecla(tecla : String)
		{
			throw new Error("Must override");
		}
		
		// --------------------------------------------------------------------
		protected function TeclaEnter()
		{
			dispatchEvent(new DataEvent(CONTROL_KEY, false, false, 'enter'));
			if(text_field != null) 
				dispatchEvent(new Event(CLICK_ENTER));
			if(allows_enter) 
				Escribir("\n");
		}
		
		// --------------------------------------------------------------------
		protected function TeclaTab()
		{
			dispatchEvent(new DataEvent(CONTROL_KEY, false, false, 'tab'));
			if(text_field != null)
				dispatchEvent(new DataEvent(CLICK_TAB, false, false, text_field.name));
			if(allows_tab)
				Escribir("    ");
		}

		// --------------------------------------------------------------------
		protected function TeclaBackSpace()
		{
			dispatchEvent(new DataEvent(CONTROL_KEY, false, false, 'backspace'));
			if(text_field != null)
			{
				text_field.text = text_field.text.substr(0, text_field.text.length-1); 	
				dispatchEvent(new DataEvent(WRITE, false, false, ""));
			}
		}

		// --------------------------------------------------------------------
		protected function Escribir(char : String)
		{
			dispatchEvent(new DataEvent(CHAR_KEY, false, false, char));
			if(text_field != null)
			{
				if(text_field.text.length < max_chars)
				{
					text_field.text += char;
					dispatchEvent(new DataEvent(WRITE, false, false, char));
				}
				else
				{
					trace("Max chars!!!");
				}
				text_field.width = Math.max(text_field.width, min_width);
				text_field.height = Math.max(text_field.height, min_height);
			}
		}
		
		// --------------------------------------------------------------------
		public function dispose()
		{
			if(uses_real_keyboard && mc_teclado.stage != null)
				mc_teclado.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			
			text_field = null;
			max_chars = 0;
			
			for (var i = 0; i < mc_teclado.numChildren; i++)
			{
				mc_teclado.getChildAt(i).removeEventListener(MouseEvent.CLICK, clickTecla);
			}
			
			removeChild(mc_teclado);
			mc_teclado = null;
		}
	}
}