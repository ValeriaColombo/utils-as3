package vale.utils.crypt
{
	public class Simplecrypt
	{
		private static var InvalidChars : Array = [{char:"á", rep:"{$a}"},
												   {char:"Á", rep:"{$A}"},
												   {char:"é", rep:"{$e}"},
												   {char:"É", rep:"{$E}"},
												   {char:"í", rep:"{$i}"},
												   {char:"Í", rep:"{$I}"},
												   {char:"ó", rep:"{$o}"},
												   {char:"Ó", rep:"{$O}"},
												   {char:"ú", rep:"{$u}"},
												   {char:"Ú", rep:"{$U}"},
												   {char:"ñ", rep:"{$n}"},
												   {char:"Ñ", rep:"{$N}"}];
												   
		static public function encrypt(str:String, key:String = '%key&'):String 
		{
			for each(var c : Object in InvalidChars)
			{
				while(str.indexOf(c.char) > -1)
					str = str.replace(c.char, c.rep);
			}
				
			var result:String = '';
			for (var i:int = 0; i < str.length; i++)
			{
				var char:String = str.substr(i, 1);
				var keychar:String = key.substr((i % key.length) - 1, 1);
				var ordChar:int = char.charCodeAt(0);
				var ordKeychar:int = keychar.charCodeAt(0);
				var sum:int = ordChar + ordKeychar;
				char = String.fromCharCode(sum);
				result = result + char;
			}
			return Base64.encode(result);
		}
		
		static public function decrypt(str:String, key:String = '%key&'):String 
		{
			var result:String = '';
			var str:String = Base64.decode(str);
			
			for (var i:int = 0; i < str.length; i++) 
			{
				var char:String = str.substr(i, 1);
				var keychar:String = key.substr((i % key.length) - 1, 1);
				var ordChar:int = char.charCodeAt(0);
				var ordKeychar:int = keychar.charCodeAt(0);
				var sum:int = ordChar - ordKeychar;
				char = String.fromCharCode(sum);
				result = result + char;
			}
			
			for each(var c : Object in InvalidChars)
			{
				while(result.indexOf(c.rep) > -1)
					result = result.replace(c.rep, c.char);
			}
			
			return result;
		}
	}
}