package sia_facebook
{
	// ========================================================================
	import com.facebook.graph.FacebookMobile;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import keyboards.IPadKeyboard;
	import keyboards.MyKeyboard;

	// ========================================================================

	public class FacebookSessionManager extends Sprite
	{
		// ====================================================================
		private static var _instance : FacebookSessionManager;
		// ====================================================================
		
		// --------------------------------------------------------------------
		public static function get Instance() : FacebookSessionManager
		{
			if(_instance == null)
				_instance = new FacebookSessionManager();
			
			return _instance;
		}
		
		// --------------------------------------------------------------------
		public function FacebookSessionManager() {}
		
		// ====================================================================
		private var id_form_pass = 0;
		private var id_form_user = 0;
		// ====================================================================
		private var readyCallback : Function;
		private var callbackLogedin : Function;
		private var callbackCancelLogin : Function;
		private var callbackLogout : Function;
		
		private var appId : String;
		private var appName : String;
		private var timeoutLoad : Number;
		private var boundsWindow : Rectangle;
		private var boundsKeyboard : Rectangle;
		private var app_permissions : Array;
		// ====================================================================
		private var connecting : ConectandoConFbMC;
		private var blocker : Blocker;
		private var helpText : McHelp;
		public var virtualKeyboard : IPadKeyboard;
		private var facebookWebView : StageWebView;
		private var closeBtn : CloseBtnMC;
		
		private var inBrowser : Boolean;
		private var loc : String = "";
		private var fbForm : int = id_form_user;
		private var fbTextName : String = "";
		private var fbTextPass : String = "";
		
		private var loggedin : Boolean;
		// ====================================================================

		/**Inicializa toda la data que vaa necesitar la clase para poder loguearse y desloguearse de facebook. 
		 * Antes de llamar a este método, hay que agregarlo a algun contenedor, para que tenga acceso al stage.
		 * @param ready_callback función que llama al terminar de inicializar
		 * @param lang idioma en el que se muestran teclado y mensajes (SupportedLangs)
		 * @param app_id id de la aplicacion de FB
		 * @param app_name URL de la aplicacion de fb (Por ej: http://games.siainteractive.com/photoipad/)
		 * @param permissions lista de permisos que requiere la aplicación (AppPermissions)
		 * @param window_bounds tamaño y posición de la ventana de fb
		 * @param timeout_logueo (si virtual_keyboard es true) tiempo que tarda en asumir que no se pudo conectar antes de refrescar la pagina (en milisegundos)
		 * @param virtual_keyboard si usa o no teclado en pantalla
		 * @param keyboard_bounds (si virtual_keyboard es true) el tamaño y ubicación del teclado
		 * @param help_bounds (si virtual_keyboard es true) el tamaño y ubicación del texto que dice "Para cambiar de campo presione TAB"
		 **/
		// --------------------------------------------------------------------
		public function Init(ready_callback : Function, 
						 	lang : String,
							app_id : String, 
							app_name : String, 
							permissions : Array,
							window_bounds : Rectangle,
							timeout_logueo : Number, 
							virtual_keyboard : Boolean = false,
							keyboard_bounds : Rectangle = null,
							help_bounds : Rectangle = null)
		{
			if(stage == null)
			{
				throw new Error("Antes hay que agregar a Instance al stage.");
				return;
			}
			
			loggedin = false;
			
			readyCallback = ready_callback;
			boundsWindow = window_bounds;
			app_permissions = permissions;
			appId = app_id;
			appName = app_name;
			timeoutLoad = timeout_logueo;
			
			if(virtual_keyboard) boundsKeyboard = keyboard_bounds;
			
			var keyboard_lang : String;
			switch(lang)
			{
				case SupportedLangs.ES: 
					keyboard_lang = MyKeyboard.LANG_ESPANOL;
					break;
				case SupportedLangs.EN: 
					keyboard_lang = MyKeyboard.LANG_ENGLISH;
					break;
				case SupportedLangs.BR: 
					keyboard_lang = MyKeyboard.LANG_PORTUGUES;
					break;
			}
			
			if(UsaTecladoVirtual)
			{
				virtualKeyboard = new IPadKeyboard(keyboard_lang, true);
				SetEscaleAndPosition(virtualKeyboard, boundsKeyboard);
				virtualKeyboard.ColorFondo(0xCCCCCC);
			}

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadConfigsCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadConfigsErrorHandler);
			loader.load(new URLRequest("http://games.siainteractive.com/frameworks/FBLoginConfigs.xml"));
			
			inBrowser = false;
			
			blocker = new Blocker();
			SetEscaleAndPosition(blocker, new Rectangle(0,0,stage.stageWidth, stage.stageHeight));

			helpText = new McHelp();
			helpText.gotoAndStop(lang);
			helpText.visible = virtual_keyboard;
			if(help_bounds != null) SetEscaleAndPosition(helpText, help_bounds);

			closeBtn = new CloseBtnMC();
			closeBtn.x = window_bounds.x - closeBtn.width + window_bounds.width;
			closeBtn.y = window_bounds.y - closeBtn.width;

			connecting = new ConectandoConFbMC();
			connecting.text.gotoAndStop(lang);
			connecting.text.x = stage.stageWidth/2;
			connecting.text.y = stage.stageHeight/2;
			SetEscaleAndPosition(connecting.bkg, new Rectangle(0,0,stage.stageWidth, stage.stageHeight));
			
			FacebookMobile.manageSession = false;
			FacebookMobile.init(appId, onInit);
		}
		
		private var callbackReInit
		public function ResetFBInstance(_callbackReInit):void 
		{
			if(blocker.parent != null) stage.removeChild(blocker);
			if(helpText.parent != null) stage.removeChild(helpText);
			if(virtualKeyboard && virtualKeyboard.parent != null) stage.removeChild(virtualKeyboard);
			if(connecting.parent != null) stage.removeChild(connecting);
			
			try
			{
				if(facebookWebView != null)
				{
					facebookWebView.reload();
					facebookWebView.dispose();
					facebookWebView = null;	
				}
			}
			catch(e:*){}
			
			try
			{
				if(closeBtn.parent != null)
				{
					stage.removeChild(closeBtn);
					closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onCloseWindow);
				}
			}
			catch(e:*){}
			
			callbackReInit = _callbackReInit;
			FacebookMobile.manageSession = false;
			FacebookMobile.init(appId, onReInit, null);
		}
		
		/**Abre la ventana de logueo a FB (antes de llamar a este método hay que hacer un Instance.Init() ).
		 * @param callback_logedin función que llama al loguearse exitosamente (tiene que ser de la forma callback(user : FbUserData) )
		 * @param callback_cancel función que llama cuando cierran la ventana sin iniciar sesion en FB
		 **/
		// --------------------------------------------------------------------
		public function FacebookLogin(callback_logedin : Function, callback_cancel : Function = null)
		{
			if(id_form_pass == 0 || id_form_user == 0)
			{
				throw new Error("Antes hay que llamar a Instance.Init(...)");
				return;
			}
				
			FacebookDebugLog.Instance.Log("FacebookSessionManager.FacebookLogin");

			callbackLogedin = callback_logedin;
			callbackCancelLogin = callback_cancel;
			
			inBrowser = true;
			
			facebookWebView = null;
			facebookWebView = new StageWebView();
			facebookWebView.stage = this.stage;
			facebookWebView.viewPort = boundsWindow;
			
			if(UsaTecladoVirtual)
				FacebookMobile.login(onfacebookLogin, this.stage, app_permissions, facebookWebView, 'popup');
			else
				FacebookMobile.login(onfacebookLogin, this.stage, app_permissions, facebookWebView);
			
			closeBtn.addEventListener(MouseEvent.MOUSE_DOWN, onCloseWindow);
			
			stage.addChild(blocker);
			stage.addChild(closeBtn);

			loc = facebookWebView.location;
			act_loc = loc;
			
			if(UsaTecladoVirtual)
			{
				removeEventListener(Event.ENTER_FRAME, veryfyFormChange);
				addEventListener(Event.ENTER_FRAME, verifyFormWithKeyboard);

				virtualKeyboard.addEventListener(MyKeyboard.CHAR_KEY, writeLetters);
				virtualKeyboard.addEventListener(MyKeyboard.CONTROL_KEY, detectComplementaryKeyboard);
				virtualKeyboard.ShowLetters();
				
				stage.addChild(virtualKeyboard);
				stage.addChild(helpText);
			}
			else
			{
				facebookWebView.addEventListener(Event.COMPLETE, onLoadPageCompleted);
			}
			
			// si estaba esto puesto, lo vuelvo a poner, para que quede arriba de todo
			if(connecting.parent != null) stage.addChild(connecting);
		}
		
		// --------------------------------------------------------------------
		private function get UsaTecladoVirtual() : Boolean
		{
			return (boundsKeyboard != null);
		}
		
		// --------------------------------------------------------------------
		private function onReInit(success:Object, fail:Object) 
		{ 
			callbackReInit() 
		}
		
		// --------------------------------------------------------------------
		private function onInit(success:Object, fail:Object) {}
		
		
		// --------------------------------------------------------------------
		private function loadConfigsErrorHandler(event:Event)
		{
			trace("loadConfigsErrorHandler");
			
			id_form_pass = "13";
			id_form_user = "12";
			
			if(readyCallback)
			{
				readyCallback();
				readyCallback = null;
			}
		}
		
		// --------------------------------------------------------------------
		private function loadConfigsCompleteHandler(event:Event)
		{
			var loader : URLLoader = event.target as URLLoader;
			var xml : XML = new XML(loader.data);
			
			id_form_pass = parseInt(xml.fb.@id_form_pass);
			id_form_user = parseInt(xml.fb.@id_form_user);
			
			if(readyCallback)
			{
				readyCallback();
				readyCallback = null;
			}
		}
		
		// --------------------------------------------------------------------
		private function writeLetters(e:DataEvent):void 
		{
			if(inBrowser)
			{
				var nLetter:String = e.data;
				
				if(fbForm == id_form_user)
				{
					fbTextName += nLetter;
					facebookWebView.loadURL("javascript:document.forms[0].elements["+fbForm+"].value = \""+fbTextName+"\"");
				}
				else if(fbForm == id_form_pass)
				{
					fbTextPass += nLetter;
					facebookWebView.loadURL("javascript:document.forms[0].elements["+fbForm+"].value = \""+fbTextPass+"\"");
				}
			}
		}
		
		private var act_loc = "";
		// --------------------------------------------------------------------
		private function verifyFormWithKeyboard(event:Event):void
		{
			try
			{
				var newLoc:String = facebookWebView.location;
				if(loc != newLoc)
				{
					act_loc = newLoc;
					fbForm = id_form_user;
					fbTextName = "";
					fbTextPass = "";
					facebookWebView.loadURL("javascript:document.forms[0].elements["+id_form_pass+"].value = \""+fbTextPass+"\"");
					facebookWebView.loadURL("javascript:document.forms[0].elements["+id_form_user+"].value = \""+fbTextName+"\"");
					facebookWebView.loadURL("javascript:document.forms[0].elements["+id_form_user+"].focus();");
					
					setTimeout(removeL, 2000);
				}
			}
			catch(e:Error){}
		}
				
		// --------------------------------------------------------------------
		private function onLoadPageCompleted(e)
		{
			facebookWebView.removeEventListener(Event.COMPLETE, onLoadPageCompleted);

			if(facebookWebView != null)
				facebookWebView.loadURL("javascript:document.getElementsByName('email')[0].placeholder = ''");
		}

		// --------------------------------------------------------------------
		private function removeL():void 
		{
			removeEventListener(Event.ENTER_FRAME, verifyFormWithKeyboard);
			addEventListener(Event.ENTER_FRAME, veryfyFormChange);
		}
		
		// --------------------------------------------------------------------
		private function veryfyFormChange(e):void 
		{
			try
			{
				if(loggedin) return;
				
				var newLoc:String = facebookWebView.location;
				if(act_loc != newLoc && newLoc.indexOf("dialog/oauth") == -1)
				{
					act_loc = loc;
					removeEventListener(Event.ENTER_FRAME, veryfyFormChange);
					facebookWebView.viewPort = new Rectangle(-500, -500, 400, 400); // La saco de la parte visible de la ventana, para que no se vea la chanchada
					
					setTimeout(IfStillNotLoggedLogout, timeoutLoad);
					
					stage.addChild(connecting);
				}
			}
			catch(e:Error){}
		}
		
		// --------------------------------------------------------------------
		private function detectComplementaryKeyboard(e:DataEvent):void
		{
			if(inBrowser)
			{
				switch(e.data)
				{
					case ("enter"):
						if(fbForm == id_form_user)
						{
							facebookWebView.loadURL("javascript:document.forms[0].elements["+id_form_pass+"].focus();");
							fbForm = id_form_pass;
						}
						else if(fbForm == id_form_pass)
						{
							facebookWebView.loadURL("javascript:document.forms[0].elements["+id_form_user+"].focus();");
							fbForm = id_form_user;
						}
						break;
					
					case ("tab"):
						if(fbForm == id_form_user)
						{
							facebookWebView.loadURL("javascript:document.forms[0].elements["+id_form_pass+"].focus();");
							fbForm = id_form_pass;
						}
						else if(fbForm == id_form_pass)
						{
							facebookWebView.loadURL("javascript:document.forms[0].elements["+id_form_user+"].focus();");
							fbForm = id_form_user;
						}
						break;
					
					case ("backspace"):
						if(facebookWebView != null)
						{
							if(fbForm == id_form_user)
							{
								fbTextName = fbTextName.substr(0, (fbTextName.length - 1));
								facebookWebView.loadURL("javascript:document.forms[0].elements["+fbForm+"].value = \""+fbTextName+"\"");
							}			
							else if(fbForm == id_form_pass)
							{
								fbTextPass = fbTextPass.substr(0, (fbTextPass.length - 1));
								facebookWebView.loadURL("javascript:document.forms[0].elements["+fbForm+"].value = \""+fbTextPass+"\"");
							}	
						}
						break;
				}
			}
		}
		
		// --------------------------------------------------------------------
		private function onCloseWindow(event : MouseEvent = null):void
		{
			removeEventListener(Event.ENTER_FRAME, veryfyFormChange);

			if(helpText.parent != null) stage.removeChild(helpText);
			if(blocker.parent != null) stage.removeChild(blocker);

			if(closeBtn.parent != null)
			{
				stage.removeChild(closeBtn);
				closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onCloseWindow);
			}
			
			facebookWebView.dispose();
			facebookWebView = null;
			
			inBrowser = false;
			if(virtualKeyboard && virtualKeyboard.parent != null) stage.removeChild(virtualKeyboard);

			if(callbackCancelLogin)
			{
				callbackCancelLogin();
				callbackCancelLogin = null;
			}
		}
		
		// --------------------------------------------------------------------
		private function onfacebookLogin(success : Object, fail : Object) : void
		{
			if(success)
			{
				var user : FbUserData = new FbUserData(success.accessToken, success.uid, success.user.first_name, success.user.last_name, success.user.email, success.user.gender);
				
				loggedin = true;
				
				if(callbackLogedin)
				{
					callbackLogedin(user);
					callbackLogedin = null;
				}
				
				if(closeBtn.parent != null)
				{
					stage.removeChild(closeBtn);
					closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onCloseWindow);
				}
				
				try
				{
					if(facebookWebView != null)
					{
						facebookWebView.dispose();
						facebookWebView = null;
					}
				}
				catch(e:*){}
				
				inBrowser = false;

				if(blocker.parent != null) stage.removeChild(blocker);
				if(helpText.parent != null) stage.removeChild(helpText);
				if(virtualKeyboard && virtualKeyboard.parent != null) stage.removeChild(virtualKeyboard);
				if(connecting.parent != null) stage.removeChild(connecting);
			}
			else if(fail)
			{
				try
				{
					facebookWebView.loadURL("https://www.facebook.com/notme.php");
				}
				catch(e:*){}
				
				if(closeBtn.parent != null)
				{
					stage.removeChild(closeBtn);
					closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onCloseWindow);
				}

				setTimeout(CancelAndTryAgain, 500);
			}
		}
		
		// --------------------------------------------------------------------
		private function IfStillNotLoggedLogout()
		{
			if(inBrowser && !loggedin)
				onfacebookLogin(null, {});
		}
		
		// --------------------------------------------------------------------
		private function CancelAndTryAgain()
		{
			if(loggedin) return;
			
			if(blocker.parent != null) stage.removeChild(blocker);
			if(helpText.parent != null) stage.removeChild(helpText);
			if(virtualKeyboard && virtualKeyboard.parent != null) stage.removeChild(virtualKeyboard);
			if(connecting.parent != null) stage.removeChild(connecting);
			
			try
			{
				if(facebookWebView != null)
				{
					facebookWebView.reload();
					facebookWebView.dispose();
					facebookWebView = null;	
				}
			}
			catch(e:*){}
			
			FacebookLogin(callbackLogedin, callbackCancelLogin);
		}
		
		// --------------------------------------------------------------------
		private function submitHandler(result:Object, fail:Object):void
		{
			
		}
		
		/**Si hay algun usuario loguado, lo desloguea (antes de llamar a este método hay que hacer un Instance.Init() ).
		 * @param callback_deslogueo función que llama al terminar de cerrar la sesion de usuario
		 **/
		// --------------------------------------------------------------------
		public function FacebookLogoutAPI(callback_deslogueo : Function)
		{
			if(id_form_pass == 0 || id_form_user == 0)
			{
				throw new Error("Antes hay que llamar a Instance.Init(...)");
				return;
			}
			
			FacebookDebugLog.Instance.Log("FacebookSessionManager.FacebookLogoutAPI");
			
			stage.addChild(blocker);
			
			callbackLogout = callback_deslogueo;
			FacebookMobile.logoutAPI(logoutHandler, appName);
		}
		
		private var retrys_logout;
		// --------------------------------------------------------------------
		public function FacebookLogoutWEB(callback_deslogueo : Function)
		{
			if(id_form_pass == 0 || id_form_user == 0)
			{
				throw new Error("Antes hay que llamar a Instance.Init(...)");
				return;
			}
			
			FacebookDebugLog.Instance.Log("FacebookSessionManager.FacebookLogoutWEB");
			
			stage.addChild(blocker);
			
			retrys_logout = 0;
			callbackLogout = callback_deslogueo;
			FacebookMobile.logoutWEB(logoutHandler, appName);
		}
		
		// --------------------------------------------------------------------
		private function logoutHandler(value:Boolean):void
		{
			FacebookDebugLog.Instance.Log("FacebookSessionManager.logoutHandler " + value);
			
			if(value)
			{
				loggedin = false;
	
				if(blocker.parent != null) stage.removeChild(blocker);
				if(callbackLogout)
				{
					callbackLogout(true);
					callbackLogout = null;
				}
			}
			else
			{
				retrys_logout++;
				if(retrys_logout < 5)
				{
					FacebookDebugLog.Instance.Log("FacebookSessionManager.logout retry");
					FacebookMobile.logoutWEB(logoutHandler, appName);
				}
				else
				{
					if(blocker.parent != null) stage.removeChild(blocker);
					if(callbackLogout)
					{
						callbackLogout(false);
						callbackLogout = null;
					}
				}
			}
		}
		
		// --------------------------------------------------------------------
		private function SetEscaleAndPosition(o : DisplayObject, bounds : Rectangle)
		{
			var scale = Math.max(bounds.width/o.width, bounds.height/o.height);
			
			o.scaleX = scale;
			o.scaleY = scale;
			o.x = bounds.x;
			o.y = bounds.y;
		}
	}
}