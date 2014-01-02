package vale.utils.events
{
	// ====================================================================
	import vale.utils.FunctionWithParameters;
	import vale.utils.FunctionWithParameters;

	// ====================================================================

	internal class EventSuscriber
	{
		// ====================================================================
		private var callback : FunctionWithParameters;
		private var unsuscribe_at_call : Boolean;
		// ====================================================================
		
		// --------------------------------------------------------------------
		public function EventSuscriber(_callback : FunctionWithParameters, _unsuscribe_at_call : Boolean)
		{
			unsuscribe_at_call = _unsuscribe_at_call;		
			callback = _callback;
		}
		
		// --------------------------------------------------------------------
		public function EventRised(data : Object = null) : Boolean
		{
			if(data != null)
				callback.CallWithParam(data);
			else
				callback.Call();
			
			return unsuscribe_at_call;
		}
	}
}