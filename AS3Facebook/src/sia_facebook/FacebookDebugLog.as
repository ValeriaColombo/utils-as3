package sia_facebook
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class FacebookDebugLog extends Sprite
	{
		private static var _instance : FacebookDebugLog;
		
		public static function get Instance() : FacebookDebugLog
		{
			if(_instance == null)
				_instance = new FacebookDebugLog();

			return _instance;
		}
		
		private var tf : TextField;
		public function FacebookDebugLog()
		{
			super();

			tf = new TextField();
			var fmt:TextFormat = new TextFormat("Verdana", 20, 0);
			tf.x = 0;
			tf.y = 0;
			tf.width = 1000;
			tf.height = 1000;
			tf.background = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;

			addChild(tf);
		}
		
		public function Log(msg : String)
		{
			tf.text += msg + "\n";
		}
		
		public function Clean()
		{
			tf.text = "";
		}
	}
}