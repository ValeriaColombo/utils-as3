package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import keyboards.IPadKeyboard;
	import keyboards.MyKeyboard;
	import keyboards.Win8Keyboard;
	
	[SWF(width="1024", height="500")]
	public class EjemploUsoTeclados extends Sprite
	{
		private var teclado : MyKeyboard;
		private var tf1 : TextField;
		private var tf2 : TextField;
		private var tf3 : TextField;
		
		public function EjemploUsoTeclados()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void
		{
			if(e != null) removeEventListener(Event.ADDED_TO_STAGE, init);
			
			tf1 = new TextField();
			setTextColor(tf1, 0xffffff, 0x800000, 0x000000);
			tf1.height = 20;
			tf1.text = "asd";
			tf1.x = 100;
			tf1.y = 350;
			addChild(tf1);
			tf1.addEventListener(MouseEvent.CLICK, clickTF1);
			
			tf2 = new TextField();
			setTextColor(tf2, 0xffffff, 0x008000, 0x000000);
			tf2.height = 20;
			tf2.text = "qwe";
			tf2.x = 100;
			tf2.y = 375;
			addChild(tf2);
			tf2.addEventListener(MouseEvent.CLICK, clickTF2);
			
			tf3 = new TextField();
			setTextColor(tf3, 0xffffff, 0x000080, 0x000000);
			tf3.height = 20;
			tf3.text = "zxc";
			tf3.x = 100;
			tf3.y = 400;
			addChild(tf3);
			tf3.addEventListener(MouseEvent.CLICK, clickTF3);
			
//			teclado = new Win8Keyboard(MyKeyboard.LANG_PORTUGUES);
			teclado = new IPadKeyboard(MyKeyboard.LANG_ESPANOL, true, true);
			addChild(teclado);
			teclado.SetTextField(tf1, 100, false, true, true);
			teclado.ColorFondo(0x00000ff);
			teclado.ColorTeclas(0x00ff00);
		}
		
		private function setTextColor(tf:TextField, color:uint, backgroundColor:uint, borderColor:uint):void
		{
			tf.textColor = color;
			tf.background = true;
			tf.backgroundColor = backgroundColor;
			tf.border = true;
			tf.borderColor = borderColor;
		}
		
		private function clickTF1(e:MouseEvent)
		{
			teclado.SetTextField(tf1, 100, false, true, true);
		}
		
		private function clickTF2(e:MouseEvent)
		{
			teclado.SetTextField(tf2, 10, (tf2.text=="qwe"));
		}
		
		private function clickTF3(e:MouseEvent)
		{
			teclado.SetTextField(tf3, 50, true);
		}
	}
}