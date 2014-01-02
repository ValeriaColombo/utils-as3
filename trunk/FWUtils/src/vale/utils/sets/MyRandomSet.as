package vale.utils.sets
{
	public class MyRandomSet extends MySet
	{
		// --------------------------------------------------------------------
		public function MyRandomSet()
		{
			super();
		}

		/** Returns a random element from the set **/
		// --------------------------------------------------------------------
		public function get ARandomElement()
		{
			if(Count == 0)
				throw new Error('The set has no elements');
				
			var i = Math.max(0, Math.min(Math.round(Math.random()*(Count-1)), Count-1));
			return Elements[i];
		}
	}
}