package vale.utils
{
	// ========================================================================
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	// ========================================================================

	/** TextField Utilities **/
	public class TextFieldUtils 
	{
		/**
		 * Set the <code>TextField</code>'s width for space characters.
		 */
		// --------------------------------------------------------------------
		public static function setTextSpaceWidth(tf:TextField, space:Number = 1)
		{
			var fmt:TextFormat = new TextFormat();
			fmt.letterSpacing = space;
			var i:int = 0;
			while (tf.text.indexOf(" ", i) > -1)
			{
				var index:int = tf.text.indexOf(" ", i);
				tf.setTextFormat(fmt, index, index + 1);
				i = index + 1;
			}
		}
		
		/**
		 * Set the <code>TextField</code> letter spacing formatting.
		 */
		// --------------------------------------------------------------------
		public static function setTextLetterSpacing(tf:TextField, spacing:Number = 0)
		{
			var fmt:TextFormat = tf.getTextFormat();
			fmt.letterSpacing = spacing;
			tf.setTextFormat(fmt);
		}
		
		/**
		 * Set the <code>TextField</code> leading formatting.
		 */
		// --------------------------------------------------------------------
		public static function setTextLeading(tf:TextField, space:Number = 0):void
		{
			var fmt:TextFormat = tf.getTextFormat();
			fmt.leading = space;
			tf.setTextFormat(fmt);
		}
		
		/**
		 * Set the <code>TextField</code> font formatting.
		 */
		// --------------------------------------------------------------------
		public static function setTextFont(tf:TextField, fontName:String, fontSize:Number, isEmbedFont:Boolean = false, isBold:Boolean = false, isItalic:Boolean = false, isUnderline:Boolean = false):void
		{
			var fmt:TextFormat = tf.getTextFormat();
			fmt.font = fontName;
			fmt.size = fontSize;
			fmt.italic = isItalic;
			fmt.bold = isBold;
			fmt.underline = isUnderline;
			tf.embedFonts = isEmbedFont;
			tf.setTextFormat(fmt);
		}
		
		/**
		 * Set the <code>TextField</code> color formatting.
		 */
		// --------------------------------------------------------------------
		public static function setTextColor(tf:TextField, color:uint, backgroundColor:uint, borderColor:uint):void
		{
			tf.textColor = color;
			tf.background = true;
			tf.backgroundColor = backgroundColor;
			tf.border = true;
			tf.borderColor = borderColor;
		}
		
		/**
		 * Apply a <code>StyleSheet</code> to a <code>TextField</code> &amp; set its contents.
		 *
		 * @param tf <code>TextField</code> to display.
		 * @param str of text to apply.
		 * @param stylesheet to apply to the <code>TextField</code>'s (Default: <code>App.css</code>).
		 *
		 * @see sekati.core.App#css
		 */
		// --------------------------------------------------------------------
		public static function setStyledText(tf:TextField, str:String, stylesheet:StyleSheet = null):void
		{
			styleFields(tf, stylesheet);
			tf.htmlText = str;
		}
		
		/**
		 * Apply the application stylesheet to a <code>TextField</code> or to all <code>TextField</code>'s in a <code>DisplayObjectContainer</code>.
		 *
		 * <p><b>Warning</b>: Unlike <code>formatFields</code> you must <i>reset</i> your <code>htmlText</code> to have the style applied.</p>
		 * @param o                     <code>DisplayObject</code> that either <i>is</i> or contains <code>TextField</code>'s.
		 * @param stylesheet    to apply to the <code>TextField</code>'s (Default: <code>App.css</code>).
		 * @see sekati.core.App#css
		 */
		// --------------------------------------------------------------------
		public static function styleFields(o:DisplayObject, stylesheet:StyleSheet):void
		{
			var tf:TextField;
			var css:StyleSheet = stylesheet;
			if (o is TextField)
			{
				tf = o as TextField;
				tf.styleSheet = css;
			}
			else if (o is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = o as DisplayObjectContainer;
				for (var i:int = 0; i < container.numChildren; i++)
				{
					if (container.getChildAt(i) is TextField)
					{
						tf = container.getChildAt(i) as TextField;
						tf.styleSheet = css;
					}
				}
			}
		}
		
		/**
		 * Apply a <code>TextFormat</code> to a <code>TextField</code> or to all <code>TextField</code>'s in a <code>DisplayObjectContainer</code>.
		 * @param o                     <code>DisplayObject</code> that either <i>is</i> or contains <code>TextField</code>'s.
		 * @param textFormat    to apply to the <code>TextField</code>'s.
		 */
		// --------------------------------------------------------------------
		public static function formatFields(o:DisplayObject, textFormat:TextFormat):void
		{
			var tf:TextField;
			if (o is TextField)
			{
				tf = o as TextField;
				tf.setTextFormat(textFormat);
			}
			else if (o is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = o as DisplayObjectContainer;
				for (var i:int = 0; i < container.numChildren; i++)
				{
					if (container.getChildAt(i) is TextField)
					{
						tf = container.getChildAt(i) as TextField;
						tf.setTextFormat(textFormat);
					}
				}
			}
		}
		
		/**
		 * Create a <code>TextField</code> instance and return it.
		 */
		// --------------------------------------------------------------------
		public static function createField(str:String, x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 20, multiline:Boolean = false, font:String = "Verdana", size:Number = 9, color:uint = 0,
									autoSize:String = 'left', embedFonts:Boolean = false, selectable:Boolean = false, css:StyleSheet = null):TextField
		{
			var tf:TextField = new TextField();
			var fmt:TextFormat = new TextFormat(font, size, color);
			tf.x = x;
			tf.y = y;
			tf.width = width;
			tf.height = height;
			tf.autoSize = autoSize;
			tf.embedFonts = embedFonts;
			tf.selectable = selectable;
			tf.multiline = multiline;
			tf.textColor = color;
			tf.defaultTextFormat = fmt;
			tf.htmlText = str;
			tf.styleSheet = css;
			return tf;
		}
		
		/**
		 * Clear a <code>TextField</code> text or to all <code>TextField</code>'s texts in a <code>DisplayObjectContainer</code>.
		 * @param o             <code>DisplayObject</code> that either <i>is</i> or contains <code>TextField</code>'s.
		 */
		// --------------------------------------------------------------------
		public static function clearFields(o:DisplayObject):void
		{
			var tf:TextField;
			if (o is TextField)
			{
				tf = o as TextField;
				tf.text = tf.htmlText = '';
			}
			else if (o is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = o as DisplayObjectContainer;
				for (var i:int = 0; i < container.numChildren; i++)
				{
					if (container.getChildAt(i) is TextField)
					{
						tf = container.getChildAt(i) as TextField;
						tf.text = tf.htmlText = '';
					}
				}
			}
		}
	}
}