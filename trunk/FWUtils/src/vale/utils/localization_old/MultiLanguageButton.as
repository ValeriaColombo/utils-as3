package vale.utils.localization_old
{
	// ========================================================================
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	// ========================================================================

	public class MultiLanguageButton
	{
		// ====================================================================
		private var enabled 	: Boolean = true;
		private var mc 			: MovieClip;

		private var al_apretar 	: Function;
		private var params 		: Object;
	
		private static var CLICK 		 : String = "click";
		private static var OVER 		 : String = "over";
		private static var CLICKEABLE 	 : String = "clickeable";
		private static var NO_CLICKEABLE : String = "no_clickeable";
		// ====================================================================
		
		// --------------------------------------------------------------------
		public function MultiLanguageButton(_mc : MovieClip, _al_apretar : Function, _params : Object = null)
		{
			params = _params;
			mc = _mc;
			al_apretar = _al_apretar;
			
			mc.stop();
			MultiLanguageAsigner.AsignText(mc.txtInfo);
			
			Enabled = true;
			
			mc.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			mc.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			mc.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		// --------------------------------------------------------------------
		public function set Enabled(e : Boolean)
		{ 
			enabled = e;
			
			var label : String = enabled ? CLICKEABLE : NO_CLICKEABLE;
			mc.gotoAndStop(label);
		}
			
		// --------------------------------------------------------------------
		private function onMouseOver(e : MouseEvent)
		{
			if(enabled)
				mc.gotoAndStop(OVER);
		}
		
		// --------------------------------------------------------------------
		private function onMouseOut(e : MouseEvent)
		{
			if(enabled)
				mc.gotoAndStop(CLICKEABLE);
		}

		// --------------------------------------------------------------------
		private function onMouseDown(e : MouseEvent)
		{
			if(enabled)
			{
				mc.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				mc.gotoAndStop(CLICK);
				al_apretar(params);
			}
		}

		// --------------------------------------------------------------------
		private function onMouseUp(e : MouseEvent)
		{
			if(enabled)
			{
				mc.gotoAndStop(CLICKEABLE);
				mc.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			}
		}
		
		// --------------------------------------------------------------------
		public function Dispose()
		{
			mc.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			mc.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			mc.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mc = null;
			al_apretar = null;
			params = null;
		}
	}
}