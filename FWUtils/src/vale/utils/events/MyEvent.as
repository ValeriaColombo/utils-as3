package vale.utils.events
{
	// ====================================================================
	import flash.utils.Dictionary;
	
	import vale.utils.FunctionWithParameters;
	import vale.utils.dictionary.MyDictionary;


	// ====================================================================

	/** Event that can be used by any class (it does not need to extend EventDispatcher) **/
	public class MyEvent
	{
		// ====================================================================
		private var suscribers 	: MyDictionary;
		private var name		: String;
		// ====================================================================
		
		/** Creates a MyEvent **/
		// --------------------------------------------------------------------
		public function MyEvent(_name : String = "")
		{
			name = _name;
			suscribers = new MyDictionary();
		}
		
		/**
		 * Works like the addEventListener.
		 * @param suscriber: the object that sucribes to the event.
		 * @param callback: The listener function that processes the event. 
		 * @param unsuscribe_at_call: unsuscribes automatucally after listening the event for the firs time
		 * @param parameters: An optional list of arguments that are passed to the closure function.
		 **/
		// --------------------------------------------------------------------
		public function Suscribe(suscriber, callback : Function, unsuscribe_at_call : Boolean = false, ...parameters)
		{
			suscribers.Define(suscriber, new EventSuscriber(new FunctionWithParameters(callback, parameters), unsuscribe_at_call));
		}
		
		/** Works like the removeEventListener. **/
		// --------------------------------------------------------------------
		public function Unsuscribe(suscriber)
		{
			suscribers.Delete(suscriber);
		}
		
		// --------------------------------------------------------------------
		public function UnsuscribeAll()
		{
			suscribers = new MyDictionary();
		}

		/** Throws the event **/
		// --------------------------------------------------------------------
		public function Rise(data : Object = null)
		{
			var unsusc : Array = new Array();
			for each(var susc in suscribers.Keys)
			{
				var suscription : EventSuscriber = suscribers.Definition(susc)
				var unsuscribe : Boolean = suscription.EventRised(data);
				if(unsuscribe)
					unsusc.push(susc);
			}
			
			for each(var uns in unsusc)
				suscribers.Delete(uns);
		}
		
		// --------------------------------------------------------------------
		public function Destroy()
		{
			UnsuscribeAll();
		}
	}
}