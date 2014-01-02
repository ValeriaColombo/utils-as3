package vale.utils.dictionary
{
	internal class DictionaryDefinition
	{
		// ====================================================================
		private var key;
		private var definition;
		// ====================================================================
		
		// --------------------------------------------------------------------
		public function DictionaryDefinition(_key, _def)
		{
			key = _key;
			definition = _def;
		}
		
		// --------------------------------------------------------------------
		public function get Key() { return key; }
		
		// --------------------------------------------------------------------
		public function get Definition() { return definition; }
	}
}