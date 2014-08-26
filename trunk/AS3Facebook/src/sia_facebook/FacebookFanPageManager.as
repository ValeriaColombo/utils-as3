package sia_facebook
{
	// ========================================================================
	import com.facebook.graph.FacebookMobile;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.utils.setTimeout;

	// ========================================================================
	
	public class FacebookFanPageManager extends Sprite
	{
		// ====================================================================
		private static var _instance : FacebookFanPageManager;
		// ====================================================================
		
		// --------------------------------------------------------------------
		public static function get Instance() : FacebookFanPageManager
		{
			if(_instance == null)
				_instance = new FacebookFanPageManager();
			
			return _instance;
		}
		
		// --------------------------------------------------------------------
		public function FacebookFanPageManager() { }
		
		// ====================================================================
		private var facebookWebView : StageWebView;

		private var urlFanPage : String;
		private var idFanPage : String;
		private var boundsWindow : Rectangle;
		// ====================================================================
		private var callbackOKLike : Function;
		private var callbackNoLike : Function;
		private var callbackLogout : Function;
		// ====================================================================
		
		/**Inicializa toda la data que vaa necesitar la clase para poder mostrar la fan page y chequear los likes. 
		 * @param url_fan_page url que se carga en la ventana (Por ej: https://www.facebook.com/siainteractive)
		 * @param id_fan_page id de la página a la que se va a chequear que el usuario haya likeado 
		 * @param window_bounds tamaño y posición de la ventana donde se abre el fb
		 **/
		// --------------------------------------------------------------------
		public function Init(url_fan_page : String, id_fan_page : String, window_bounds : Rectangle)
		{
			boundsWindow = window_bounds;
			urlFanPage = url_fan_page;
			idFanPage = id_fan_page;
		}
			
		/**Abre un browser con la fan page (antes de llamar a este método hay que hacer un Instance.Init() ).
		 * Antes de llamar a este método, hay que agregarlo a algun contenedor, para que tenga acceso al stage.
		 **/
		// --------------------------------------------------------------------
		public function ShowFanPage()
		{
			if(stage == null)
			{
				throw new Error("Antes hay que agregar a Instance al stage.");
				return;
			}
			
			if(boundsWindow == null)
			{
				throw new Error("Antes hay que llamar a Instance.Init(...)");
				return;
			}
			
			showBrowser();
		}
		
		/**Cierra el browser. 
		 **/
		// --------------------------------------------------------------------
		public function Close()
		{
			removeBrowser();
		}
		
		/** Chequea que el usuario logueado le haya dado like a la pagina que se esta mostrando.
		 * @param callback_ok Funcion que llama al verificar que el usuario ya dio like
		 * @param calback_error Funcion que llama al verificar que el usuario aun no dio like
		 **/
		// --------------------------------------------------------------------
		public function CheckLike(callback_ok : Function, calback_error : Function = null)
		{
			callbackOKLike = callback_ok;
			callbackNoLike = calback_error;
			
			FacebookMobile.api("me/likes/", onLikeHandler);
		}
		
		// --------------------------------------------------------------------
		public function refreshBrowser():void
		{
			facebookWebView.reload();
		}

		// --------------------------------------------------------------------
		public function LogoutVisible(callback : Function)
		{
			callbackLogout = callback;
			FacebookSessionManager.Instance.FacebookLogoutAPI(onLogout);
		}
	
		// --------------------------------------------------------------------
		private function onLogout()
		{
			FacebookFanPageManager.Instance.refreshBrowser();
			setTimeout(EndVisibleLogout,3000);
		}
		
		// --------------------------------------------------------------------
		private function EndVisibleLogout()
		{
			Close();

			if(callbackLogout)
			{
				callbackLogout();
				callbackLogout = null
			}
		}
		
		// --------------------------------------------------------------------
		private function onLikeHandler(result:Object, fail:Object):void
		{
			if(result)
			{
				for(var i = 0; i < result.length; i++)
				{
					if(result[i].id == idFanPage)
					{
						callbackOKLike();
						return;
					}
				}
			}

			if(callbackNoLike != null)
				callbackNoLike();
			
			return;
		}
		
		// --------------------------------------------------------------------
		private function showBrowser():void
		{
			if(facebookWebView != null)
			{
				facebookWebView.dispose();
				facebookWebView = null;
			}
			
			facebookWebView = new StageWebView();
			facebookWebView.stage = this.stage;
			facebookWebView.viewPort = boundsWindow;
			facebookWebView.loadURL(urlFanPage);
		}
		
		// --------------------------------------------------------------------
		private function removeBrowser():void
		{
			try
			{
				callbackOKLike = null;
				callbackNoLike = null;
				
				if(facebookWebView != null)
				{
					facebookWebView.dispose();
					facebookWebView = null;
				}
			}
			catch(e:*){}
		}
	}
}