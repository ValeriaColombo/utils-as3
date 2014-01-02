package vale.utils.sets
{
	public class MySet
	{
		// ====================================================================
		private var elements : Array;
		// ====================================================================
		
		// --------------------------------------------------------------------
		public function MySet()
		{
			elements = new Array();
		}
		
		// --------------------------------------------------------------------
		public function Add(element)
		{
			elements.push(element);
		}
		
		// --------------------------------------------------------------------
		public function Remove(element)
		{
			var new_elems : Array = new Array();
			for each(var e in elements)
			{
				if(e != element)
					new_elems.push(e);
			}
			elements = new_elems;
		}

		// --------------------------------------------------------------------
		public function get Count() : int { return elements.length; }
		
		// --------------------------------------------------------------------
		public function get Elements() : Array { return elements; }
		
		// --------------------------------------------------------------------
		public function Destroy()
		{
			elements = null;
		}
	}
}