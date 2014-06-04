package keyboards
{
	// ========================================================================
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;

	// ========================================================================

	/**
	 *  Teclado estilo Windows 8
	 **/
	public class NumericKeyboard extends MyKeyboard
	{
		// ====================================================================
		// ====================================================================
		
		/**
		 *	@param _lang puede ser "ES"(MyKeyboard.LANG_ESPANOL), "EN"(MyKeyboard.LANG_ENGLISH) o "BR"(MyKeyboard.LANG_PORTUGUES).
		 *	@param _uses_real_keyboard Si se puede usar o no el teclado fisico (solo letras y numeros).
		 */
		// --------------------------------------------------------------------
		public function NumericKeyboard(_uses_real_keyboard : Boolean = false)
		{
			mc_teclado = new mcTecladoNumerico();
			addChild(mc_teclado);
			
			super("ES", _uses_real_keyboard);
		}
		
		// --------------------------------------------------------------------
		protected override function onKeyboardDown(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case 8: ApretarTecla("BACKSPACE"); break;
				case 48: ApretarTecla("CERO"); break;
				case 49: ApretarTecla("UNO"); break;
				case 50: ApretarTecla("DOS"); break;
				case 51: ApretarTecla("TRES"); break;
				case 52: ApretarTecla("CUATRO"); break;
				case 53: ApretarTecla("CINCO"); break;
				case 54: ApretarTecla("SEIS"); break;
				case 55: ApretarTecla("SIETE"); break;
				case 56: ApretarTecla("OCHO"); break;
				case 57: ApretarTecla("NUEVE"); break;
				case 190: ApretarTecla("PUNTO"); break;
				case 96: ApretarTecla("CERO"); break;
				case 97: ApretarTecla("UNO"); break;
				case 98: ApretarTecla("DOS"); break;
				case 99: ApretarTecla("TRES"); break;
				case 100: ApretarTecla("CUATRO"); break;
				case 101: ApretarTecla("CINCO"); break;
				case 102: ApretarTecla("SEIS"); break;
				case 103: ApretarTecla("SIETE"); break;
				case 104: ApretarTecla("OCHO"); break;
				case 105: ApretarTecla("NUEVE"); break;
				case 110: ApretarTecla("PUNTO"); break;
			}
		}
		
		// --------------------------------------------------------------------
		protected override function ApretarTecla(tecla : String)
		{
			switch(tecla)
			{
				case "UNO": Escribir("1"); 	
					break;
				case "DOS": Escribir("2");	
					break;
				case "TRES": Escribir("3"); 	
					break;
				case "CUATRO": Escribir("4"); 	
					break;
				case "CINCO": Escribir("5");	
					break;
				case "SEIS": Escribir("6"); 	
					break;
				case "SIETE": Escribir("7"); 	
					break;
				case "OCHO": Escribir("8");	
					break;
				case "NUEVE": Escribir("9");	
					break;
				case "CERO": Escribir("0");
					break;
				case "PUNTO": Escribir("."); 	
					break;
				case "BACKSPACE": 
					TeclaBackSpace();
					break;
			}
		}
	}
}