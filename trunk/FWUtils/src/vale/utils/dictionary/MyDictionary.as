package vale.utils.dictionary
{
	public class MyDictionary
	{
		// ====================================================================
		private var definitions : Array;
		// ====================================================================

		// --------------------------------------------------------------------
		public function MyDictionary()
		{
			definitions = new Array();
		}
		
		// --------------------------------------------------------------------
		public function Define(_key, _def)
		{
			definitions.push(new DictionaryDefinition(_key, _def));
		}
		
		// --------------------------------------------------------------------
		public function Delete(_key)
		{
			var new_defs : Array = new Array();
			for each(var def : DictionaryDefinition in definitions)
			{
				if(def.Key != _key)
					new_defs.push(def);
			}
			definitions = new_defs;
		}
		
		// --------------------------------------------------------------------
		public function HasDefinition(_key) : Boolean
		{
			for each(var def : DictionaryDefinition in definitions)
			{
				if(def.Key == _key)
					return true;
			}
			return false;
		}
		
		// --------------------------------------------------------------------
		public function get Keys() : Array
		{
			var keys : Array = new Array();
			for each(var def : DictionaryDefinition in definitions)
			{
				keys.push(def.Key);
			}
			return keys;
		}
		
		// --------------------------------------------------------------------
		public function Definition(_key) : *
		{
			for each(var def : DictionaryDefinition in definitions)
			{
				if(def.Key == _key)
					return def.Definition;
			}
			throw new Error('The key is not defined in the dictionary');
		}
		
		// --------------------------------------------------------------------
		public function Destroy()
		{
			definitions = null;
		}
	}
}