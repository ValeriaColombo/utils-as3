package vale.utils.p2p
{
	// ========================================================================
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;

	// ========================================================================
	
	public class P2PComunicator extends EventDispatcher
	{
		// ====================================================================
		private var netConn:NetConnection;
		private var group:NetGroup;

		public static var INITIALIZATION_COMPLETED : String = "P2PComunicator_INITIALIZATION_COMPLETED";
		public static var MESSAGE_RECEIVED : String = "P2PComunicator_MESSAGE_RECEIVED";
		// ====================================================================
		
		// --------------------------------------------------------------------
		public function P2PComunicator()
		{
			netConn = new NetConnection();
			netConn.addEventListener(NetStatusEvent.NET_STATUS, netHandler);
			netConn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
			netConn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
			netConn.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			netConn.connect("rtmfp:");
		}
		
		// --------------------------------------------------------------------
		protected function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
			throw new Error("SecurityErrorHandler: " + event.text);
		}
		
		// --------------------------------------------------------------------
		protected function AsyncErrorHandler(event:AsyncErrorEvent):void
		{
			throw new Error("AsyncErrorHandler: " + event.text);
		}
		
		// --------------------------------------------------------------------
		protected function IOErrorHandler(event:IOErrorEvent):void
		{
			throw new Error("IOErrorHandler: " + event.text);
		}


		// --------------------------------------------------------------------
		private function netHandler(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					setupGroup();
					break;
				case "NetGroup.Connect.Success":
					break;
				case "NetGroup.SendTo.Notify":
					ReceiveMessage(event.info.message);
					break;
			}
		}
		
		protected function get NombreGrupo() : String { throw new Error("override "); }
		
		// --------------------------------------------------------------------
		private function setupGroup():void
		{
			if(group == null)
			{
				var groupspec:GroupSpecifier = new GroupSpecifier(NombreGrupo);
				groupspec.postingEnabled = true;
				groupspec.routingEnabled = true;
				groupspec.ipMulticastMemberUpdatesEnabled = true;
				groupspec.addIPMulticastAddress("225.225.0.1:30000");
				
				group = new NetGroup(netConn, groupspec.groupspecWithAuthorizations());
				group.addEventListener(NetStatusEvent.NET_STATUS, netHandler);

				dispatchEvent(new Event(INITIALIZATION_COMPLETED));
			}
		}
		
		// --------------------------------------------------------------------
		public function SendMessage(msg : String, data : Object)
		{
			var obj : Object = new Object();
			obj.msg = msg;
			obj.data = data;
			
			group.sendToAllNeighbors(obj);
		}
		
		// --------------------------------------------------------------------
		protected function ReceiveMessage(obj : Object)
		{
			var msg : String = obj.msg;
			var data : Object = obj.data;

			dispatchEvent(new P2PMessageEvent(MESSAGE_RECEIVED, msg, data));
		}
	}
}