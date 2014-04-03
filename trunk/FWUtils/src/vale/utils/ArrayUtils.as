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
	}
}