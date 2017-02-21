package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.ui.ContextMenu;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	import flash.display.StageAlign; 
	import flash.display.StageScaleMode;
	
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	public class Preloader extends MovieClip{ 
		
		private var view:Scene;
		private var model_data:Model;
		private var loading_bar:Loading_bar;
		
		private var bLoaded: uint = loaderInfo.bytesLoaded;
		private var bTotal: uint = loaderInfo.bytesTotal;
		private var Timer_Test:Timer = new Timer(10, 5); //50 
		private var my_menu:ContextMenu;
		
		
		
		/*********************************************
		 *      Конструктор основного класса         *
		 *                                           *
		 */ //****************************************
		
		 public function Preloader() {
		
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		 }
		 
		 public function init(e:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, Key_DOWN);
			
			loading_bar = new Loading_bar();
			//loading_bar.loading_mask.scaleY = 0;
			loading_bar.loading_mask.scaleX = 0;
			addChild(loading_bar);
			
			Timer_Test.addEventListener(TimerEvent.TIMER, checkLoading);
			Timer_Test.start();
			
			// удаление лишнего меню флешки
			my_menu = new ContextMenu();
			my_menu.hideBuiltInItems();
			contextMenu = my_menu;
			
			model_data = new Model();
		}
	
		private function ioError(e:IOErrorEvent):void { 
			trace(e.text);
		}
		
		
		
		
		
		/*********************************************
		 *        Проверка процента загрузки         *
		 *             и вывод на экран              *
		 */ //****************************************
		
		 private function checkLoading(event: TimerEvent):void {
			
			// формула с задержкой, что бы полюбоваться индикатором загрузки 
			var drop: int = 100 * (Timer_Test.currentCount * bLoaded) / (Timer_Test.repeatCount * bTotal);
			
			// формула без задержки
			//var drop: int = 100 * (bLoaded / bTotal);
			
			// масштабирование индикатора загрузки
			//loading_bar.loading_mask.scaleY = drop / 100;
			loading_bar.loading_mask.scaleX = drop / 100;
			
			if (drop >= 100) loadingFinished();
		}
		
		
		
		/*********************************************
		 *       Когда вся флешка загрузится         *
		 *                  до 100%                  *
		 */ //****************************************
		
		private function loadingFinished():void {
			
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			Timer_Test.reset();
			removeChild(loading_bar);
			loading_bar = null;
			
			// удаление желтой рамочки с элементов для листания элементов с клавиатуры
			stage.stageFocusRect = false;

			gotoAndStop(3);
			view = new Scene(model_data, stage);
			view.x = 0;
			view.y = 0;
			addChild(view);
		}
		
		
		
		/*********************************************
		 *          Кнопка клавиатуры "Space"        *
		 *                                           *
		 */ //****************************************
		 
		// charCode - код символа; keyCode - код клавиши
		//trace(String.fromCharCode(event.charCode));

		public	function Key_DOWN(event: KeyboardEvent) {
		
			if (view != null) {
				if (view.config_bar != null) { // если открыт конфигбар
					if (event.keyCode == 27 || event.keyCode == 32) { // клавиша "Esc"/"Space"
						if (view.config_bar.about_scr != null) { // если открыто окно "О программе"
							view.config_bar.about_scr.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						}
						if (!view.open_config.isPlaying) {
							view.config_bar.config_bar_off.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
							view.config_bar.config_bar_off.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP)); // для устранения перетаскивания конфигбара
						}
					}
				} // если закрыт конфигбар
				else if (view.config_bar == null && view.splash_screen == null) {
					if (event.keyCode == 32) { // нажатие "Space"
						view.config_bar_on.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}

// TODO: для корректного отображения лоадингбара, нужно попробовать добавить в 3-й кадр (в котором флешка никогда не будет) все визуальные классы



