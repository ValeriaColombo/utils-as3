package vale.utils 
{
	public class FunctionWithParameters
	{
		// ====================================================================
		private var funct : Function
		private var params : Array
		// ====================================================================
		
		/**Creates a FunctionWithParameters.
		 * @param _func : The Function that is going to be called
		 * @param _params : Array of parameters. It holds max 5 parameters.
		**/
		// --------------------------------------------------------------------
		public function FunctionWithParameters(_funct : Function, _params : Array)
		{
			if(_params.length > 5)
				throw new Error('FunctionWithParameters does not support more than 5 parameters');

			funct = _funct;
			params = _params;
		}
		
		/** Executes the function **/
		// --------------------------------------------------------------------
		public function Call()
		{
			if(params.length == 0)
				funct();
			else if(params.length == 1)
				funct(params[0]);
			else if(params.length == 2)
				funct(params[0], params[1]);
			else if(params.length == 3)
				funct(params[0], params[1], params[2]);
			else if(params.length == 4)
				funct(params[0], params[1], params[2], params[3]);
			else if(params.length == 5)
				funct(params[0], params[1], params[2], params[3], params[4]);
		}
		
		/** Executes the function adding one more paramter to the ones added when crated**/
		// --------------------------------------------------------------------
		public function CallWithParam(o : Object)
		{
			if(params.length == 0)
				funct(o);
			else if(params.length == 1)
				funct(params[0], o);
			else if(params.length == 2)
				funct(params[0], params[1], o);
			else if(params.length == 3)
				funct(params[0], params[1], params[2], o);
			else if(params.length == 4)
				funct(params[0], params[1], params[2], params[3], o);
			else if(params.length == 5)
				funct(params[0], params[1], params[2], params[3], params[4], o);
		}
	}
}