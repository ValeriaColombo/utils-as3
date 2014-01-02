package
{
	// ========================================================================
	import com.facebook.graph.FacebookMobile;
	
	import flash.display.Bitmap;
	// ========================================================================

	public class FacebookPhotoPost
	{
		// ====================================================================
		private static var photo   : Bitmap;
		private static var album_name : String;
		private static var album_description : String;
		private static var photo_message : String;
		private static var photo_name : String;
		
		private static var callback_ok : Function;
		private static var callback_error : Function;
		// ====================================================================
		
		/**Sube una foto al facebook del usuario logueado. 
		 * @param _album_name Nombre del album al que sube la foto (si no existe lo crea)
		 * @param _album_description descripcion del album, si el album ya existe, esto no se usa (es un texto, puede contener links)
		 * @param _photo_name descripcion de la foto (es un texto, puede contener links) 
		 * @param _photo_message 
		 * @param _photo foto a postear
		 * @param _callback_ok (opcional)
		 * @param _callback_error (opcional)
		 **/
		// --------------------------------------------------------------------
		public static function UploadPhoto(_album_name : String, _album_description : String, _photo_name : String, _photo_message : String, _photo : Bitmap, _callback_ok : Function = null, _callback_error : Function = null)
		{
			photo = _photo;
			photo_message = _photo_message;
			photo_name = _photo_name;
			album_description = _album_description;
			album_name = _album_name;
			callback_ok = _callback_ok;
			callback_error = _callback_error;
			
			FacebookMobile.api("/me/albums", checkAlbumHandler);
		}
		
		// --------------------------------------------------------------------
		private static function checkAlbumHandler(result:Object, fail:Object):void
		{
			if(result)
			{
				for(var i : int = 0; i < result.length; i++)
				{
					if(result[i].name == album_name)
					{
						uploadAndSavePhoto(result[i].id);
						return;
					}
				}
				FacebookMobile.api("/me/albums", createAlbumHandler, {name:album_name, message:album_description}, "POST");			
			}
		}
		
		// --------------------------------------------------------------------
		private static function createAlbumHandler(result:Object, fail:Object):void
		{
			uploadAndSavePhoto(result.id);
		}
		
		// --------------------------------------------------------------------
		private static function uploadAndSavePhoto(albumId:String):void
		{
			var mensaje:Object = {image:photo, name:photo_name, message:photo_message, fileName:'FILE_NAME'};
			FacebookMobile.api("/"+albumId+"/photos", handleUploadComplete, mensaje, "POST");
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
			
			photo = null;
			photo_message = "";
			photo_name = "";
			album_description = "";
			album_name = "";
			callback_ok = null;
			callback_error = null;
		}
	}
}