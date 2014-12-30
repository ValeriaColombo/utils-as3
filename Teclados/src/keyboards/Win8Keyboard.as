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
	import flash.utils.setTimeout;

	// ========================================================================

	/**
	 *  Teclado estilo Windows 8
	 **/
	public class Win8Keyboard extends MyKeyboard
	{
		// ====================================================================
		// ====================================================================
		
		/**
		 *	@param _lang puede ser "ES"(MyKeyboard.LANG_ESPANOL), "EN"(MyKeyboard.LANG_ENGLISH) o "BR"(MyKeyboard.LANG_PORTUGUES).
		 *	@param _uses_real_keyboard Si se puede usar o no el teclado fisico (solo letras y numeros).
		 */
		// --------------------------------------------------------------------
		public function Win8Keyboard(_lang : String = "ES", _uses_real_keyboard : Boolean = false)
		{
			mc_teclado = new mcTecladoWin8();
			mc_teclado.teclado.lang.gotoAndStop(_lang);
			addChild(mc_teclado);
			
			super(_lang, _uses_real_keyboard);
			setTimeout(Langggg, 200);
		}
		
		private function Langggg()
		{
			mc_teclado.teclado.lang.gotoAndStop(lang);
		}

		// --------------------------------------------------------------------
		protected override function onKeyboardDown(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case 8: ApretarTecla("BACKSPACE"); break;
				case 9: ApretarTecla("TAB"); break;
				case 13: ApretarTecla("ENTER"); break;
				case 32: ApretarTecla("SPACE"); break;
				case 65: ApretarTecla("A"); break;
				case 66: ApretarTecla("B"); break;
				case 67: ApretarTecla("C"); break;
				case 68: ApretarTecla("D"); break;
				case 69: ApretarTecla("E"); break;
				case 70: ApretarTecla("F"); break;
				case 71: ApretarTecla("G"); break;
				case 72: ApretarTecla("H"); break;
				case 73: ApretarTecla("I"); break;
				case 74: ApretarTecla("J"); break;
				case 75: ApretarTecla("K"); break;
				case 76: ApretarTecla("L"); break;
				case 77: ApretarTecla("M"); break;
				case 78: ApretarTecla("N"); break;
				case 79: ApretarTecla("O"); break;
				case 80: ApretarTecla("P"); break;
				case 81: ApretarTecla("Q"); break;
				case 82: ApretarTecla("R"); break;
				case 83: ApretarTecla("S"); break;
				case 84: ApretarTecla("T"); break;
				case 85: ApretarTecla("U"); break;
				case 86: ApretarTecla("V"); break;
				case 87: ApretarTecla("W"); break;
				case 88: ApretarTecla("X"); break;
				case 89: ApretarTecla("Y"); break;
				case 90: ApretarTecla("Z"); break;
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
				case 189: ApretarTecla("MENOS"); break;
				case 191: ApretarTecla("Ñ"); break;
				case 192: ApretarTecla("Ñ"); break;
			}
		}
		
		// --------------------------------------------------------------------
		protected override function ApretarTecla(tecla : String)
		{
			switch(tecla)
			{
				case "A": Escribir("a"); 	
					break;
				case "B": Escribir("b");	
					break;
				case "C": Escribir("c");
					break;
				case "D": Escribir("d");
					break;
				case "E": Escribir("e");
					break;
				case "F": Escribir("f"); 
					break;
				case "G": Escribir("g");	
					break;
				case "H": Escribir("h");	
					break;
				case "I": Escribir("i");	
					break;
				case "J": Escribir("j");	
					break;
				case "K": Escribir("k");	
					break;
				case "L": Escribir("l");	
					break;
				case "M": Escribir("m");	
					break;
				case "N": Escribir("n");	
					break;
				case "Ñ": 
					if(lang == LANG_ESPANOL)		Escribir("ñ");
					else if(lang == LANG_PORTUGUES)	Escribir("ç");
					break;
				case "O": Escribir("o");	
					break;
				case "P": Escribir("p");	
					break;
				case "Q": Escribir("q");	
					break;
				case "R": Escribir("r");	
					break;
				case "S": Escribir("s");	
					break;
				case "T": Escribir("t");	
					break;
				case "U": Escribir("u");	
					break;
				case "V": Escribir("v");	
					break;
				case "W": Escribir("w");	
					break;
				case "X": Escribir("x");	
					break;
				case "Y": Escribir("y");	
					break;
				case "Z": Escribir("z");	
					break;
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
				case "GUION_BAJO": Escribir("_");
					break;
				case "MENOS": Escribir("-");
					break;
				case "SPACEBAR": Escribir(" ");
					break;
				case "ARROBA": Escribir("@");
					break;
				case "BACKSPACE": 
					TeclaBackSpace();
					break;
				case "ENTER": 
					TeclaEnter()
					break;
				case "TAB":
					TeclaTab();
					break;
			}
		}
	}
}