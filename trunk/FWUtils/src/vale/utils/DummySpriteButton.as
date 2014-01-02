package vale.utils
{
	// ====================================================================
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	// ====================================================================
	
	public class DummySpriteButton extends Sprite
	{
		public function DummySpriteButton(onClick : Function, pos : Point, color = 0xff0000, size=50)
		{
			super();
			graphics.beginFill(color);
			graphics.drawCircle(pos.x, pos.y, size);
			graphics.endFill();
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
	}
}