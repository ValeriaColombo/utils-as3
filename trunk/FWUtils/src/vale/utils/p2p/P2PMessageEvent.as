package vale.utils.p2p
{
	// ========================================================================
	import flash.events.Event;
	// ========================================================================
	
	public class P2PMessageEvent extends Event
	{
		// ====================================================================
		private var _msg : String;
		private var _data : Object;
		// ====================================================================
		
		// --------------------------------------------------------------------
		public function P2PMessageEvent(type : String, msg : String, data : Object)
		{
			_msg = msg;
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		// --------------------------------------------------------------------
		public function get Msg() : String { return _msg; }

		// --------------------------------------------------------------------
		public function get Data() : Object { return _data }
	}
}