package sia_facebook
{
	// ========================================================================
	import com.facebook.graph.FacebookMobile;
	// ========================================================================

	public class FacebookWallFeedPost
	{
		// ====================================================================
		private static var post_message : String;
		
		private static var callback_ok : Function;
		private static var callback_error : Function;
		// ====================================================================
		
		/**Postea un texto (puede contener links) en el muro del usuario logueado. 
		 * @param _post_message texto que se postea
		 * @param _callback_ok (opcional)
		 * @param _callback_error (opcional)
		 **/
		// --------------------------------------------------------------------
		public static function PostFeed(_post_message : String, _callback_ok : Function = null, _callback_error : Function = null)
		{
			post_message = _post_message;
			callback_ok = _callback_ok;
			callback_error = _callback_error;
			
			var mensaje:Object = {message : post_message};
			FacebookMobile.api("/me/feed", handleUploadComplete, mensaje, "POST");
		}
		
		// --------------------------------------------------------------------
		private static function handleUploadComplete(response:Object, fail:Object):void
		{
			if(response)
			{
				if(callback_ok != null)
					callback_ok(response);
			}
			else
			{
				if(callback_error != null)
					callback_error(fail);
			}
			
			post_message = "";
			callback_ok = null;
			callback_error = null;
		}
	}
}