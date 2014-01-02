package vale.utils 
{
	// ========================================================================
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	// ========================================================================

	/** Implements the setTimout a custom number of times. 
	 * It is cancellable. **/
	public class Alarm
	{
		// ====================================================================
		private var callback	: FunctionWithParameters;
		private var repetitions	: int;
		private var delay		: int;
		
		private var timer;
		// ====================================================================
		
		/**
		 * Creates an Alarm.
		 * @param	_delay: The delay, in milliseconds, until the function is executed.
		 * @param	_callback: The name of the function to execute. Do not include quotation marks or parentheses, and do not specify parameters of the function to call. 
		 * @param	_repetitions: times the alarm implements the setTimeout. For infinite repetitons use -1.
		 * @param 	parameters: An optional list of arguments that are passed to the closure function.
		 **/
		// --------------------------------------------------------------------
		public function Alarm(_delay : int, _callback : Function, _repetitions : int = 1, ...parameters)
		{
			delay = _delay;
			callback = new FunctionWithParameters(_callback, parameters);
			repetitions = _repetitions;
			
			timer = setTimeout(onTimeout, delay);
		}
		
		// --------------------------------------------------------------------
		private function onTimeout()
		{
			callback.Call();

			repetitions--;
			if(repetitions != 0)
				timer = setTimeout(onTimeout, delay);
		}
		
		/** Stops the alarm. **/
		// --------------------------------------------------------------------
		public function Stop()
		{
			clearTimeout(timer);
			repetitions = 1;
		}
	}
}