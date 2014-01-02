package vale.utils.localization_old
{
	// ============================================================================
	import flash.utils.Dictionary;
	// ============================================================================

	public class Fonts
	{
		// ========================================================================
		private static var _instance : Fonts;
		
		private var app_fonts : Dictionary;
		// ========================================================================
		
		// ------------------------------------------------------------------------		
		public function Fonts()
		{
		}
		
		// ------------------------------------------------------------------------		
		public static function get Instance() : Fonts 
		{
			if(_instance == null)
				_instance = new Fonts();
			
			return _instance;
		}
		
		// ------------------------------------------------------------------------		
		public function InitializeFonts(_app_fonts : Dictionary)
		{
			app_fonts = _app_fonts;
		}
		
		// ------------------------------------------------------------------------		
		public function FontNamed(font_name : String)
		{
			if(app_fonts == null) throw new Error('Fonts not initialized');

			return app_fonts[font_name];
		}
	}
}