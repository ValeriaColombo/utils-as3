package vale.utils.images
{
	// ========================================================================
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	// ========================================================================

	public class ImageUtils
	{
		// ------------------------------------------------------------------------
		public static function Foto2JPEGString(photo_data : BitmapData, quality : int = 100) : String
		{
			if(photo_data != null)
			{
				var myEncoder:JPEGEncoder = new JPEGEncoder(quality);
				var byteArray:ByteArray = myEncoder.encode(photo_data);    
				return Base64.encode(byteArray);
			}
			throw new Error("photo_data is null");	
		}
		
		// ------------------------------------------------------------------------
		public static function Foto2JPEGByteArray(photo_data : BitmapData, quality : int = 100) : ByteArray
		{
			if(photo_data != null)
			{
				var myEncoder:JPEGEncoder = new JPEGEncoder(quality);
				var byteArray:ByteArray = myEncoder.encode(photo_data);    
				return byteArray;
			}
			throw new Error("photo_data is null");	
		}
		
		// ------------------------------------------------------------------------
		public static function JPEGString2Foto(photo_data : String, w: Number, h : Number) : BitmapData
		{
			if(photo_data != "")
			{
				var byteArray:ByteArray = Base64.decode(photo_data);
				var bmpData = new BitmapData(w,h);
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.INIT, function(e:Event):void {
					bmpData.draw(loader);
				});
				
				loader.loadBytes(byteArray);
				return bmpData;
			}
			throw new Error("photo_data is empty");	
		}
		
		// ------------------------------------------------------------------------
		public static function HexaToUint(hexa : String) : uint
		{
			return uint("0x" + hexa.toUpperCase());
		}
		
		/**
		 *	Returns {y:Number, u:Number, v:Number}
		 */
		// ------------------------------------------------------------------------
		public static function RGBToYUV(r : uint, g : uint, b : uint) : Object 
		{
			var o : Object = new Object();
			o.y = (0.257 * r) + (0.504 * g) + (0.098 * b) + 16;
			o.u = -(0.148 * r) - (0.291 * g) + (0.439 * b) + 128;
			o.v = (0.439 * r) - (0.368 * g) - (0.071 * b) + 128;
			return o;
		}
		
		/**
		 *	Returns {l:Number, h:Number, s:Number}
		 */
		// ------------------------------------------------------------------------
		public static function RGBToHLS(r : uint, g : uint, b : uint) : Object 
		{
			var rR = r / 255
			var rG = g / 255
			var rB = b / 255
			
			var Max = Maximum(rR, rG, rB)
			var Min = Minimum(rR, rG, rB)
			var delta 
			
			var l = (Max + Min) / 2
			var s
			var h
			
			if (Max == Min)
			{	
				//Acrhomatic case
				s = 0 
				h = 0 
			}
			else
			{	
				//Chromatic case
				if (l <= 0.5) 
					s = (Max - Min) / (Max + Min) 
				else 
					s = (Max - Min) / (2 - Max - Min) 
				
				delta = Max - Min 
				if (rR = Max)
					h = (rG - rB) / delta
				else if (rG = Max) 
					h = 2 + (rB - rR) / delta 
				else if (rB == Max) 
					h = 4 + (rR - rG) / delta 
			}
			
			var o : Object = new Object();
			o.l = l;
			o.s = s;
			o.h = h;
			return o;
		}
		
		// ------------------------------------------------------------------------
		private static function Maximum(rR, rG, rB)
		{
			if (rR > rG)
			{	
				if (rR > rB) 
					return rR 
				else 
					return rB 
			}
			else 
			{
				if (rB > rG) 
					return rB 
				else 
					return rG 
			}
		}
		
		// ------------------------------------------------------------------------
		private static function Minimum(rR, rG, rB)
		{
			if (rR < rG)
			{	
				if (rR < rB) 
					return rR 
				else 
					return rB 
			}
			else 
			{
				if (rB < rG) 
					return rB 
				else 
					return rG 
			}
		}
		
		// ------------------------------------------------------------------------
		static public function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject 
		{
			// create duplicate
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
			
			// duplicate properties
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			if (target.scale9Grid) 
			{
				var rect:Rectangle = target.scale9Grid;
				// WAS Flash 9 bug where returned scale9Grid is 20x larger than assigned
				// rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent) 
			{
				target.parent.addChild(duplicate);
			}
			
			return duplicate;
		}
		
		// ------------------------------------------------------------------------
		static public function duplicateImageAsSprite( original:DisplayObject ):Sprite
		{
			var bitmapData:BitmapData = new BitmapData( original.width , original.height ,
				true , 0x000000 );
			bitmapData.draw( original as IBitmapDrawable );
			
			var bitmap:Bitmap = new Bitmap( bitmapData );
			
			var returnSprite:Sprite = new Sprite();
			returnSprite.addChild( bitmap as DisplayObject );
			
			return returnSprite;
		}
	}
}