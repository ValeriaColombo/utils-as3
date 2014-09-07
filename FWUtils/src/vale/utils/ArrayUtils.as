package vale.utils
{
	public class ArrayUtils
	{
		// --------------------------------------------------------------------
		public static function SinRepetidos(arr : Array) : Array
		{
			var nuevo : Array = [];
			
			for each(var o in arr)
			{
				if(nuevo.indexOf(o) == -1)
					nuevo.push(o);
			}
			
			return nuevo;
		}
		
		// --------------------------------------------------------------------
		public static function RemoveItem(arr : Array, it : Object) : Array
		{
			var nuevo : Array = [];
			
			for each(var item in arr)
			{
				if(item != it)
					nuevo.push(item);
			}
			
			return nuevo;
		}
	}
}