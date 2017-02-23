package
{
	import flash.display.MovieClip;
	import flash.events.IOErrorEvent;
	import flash.ui.ContextMenu;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.display.Stage;
	
	//import flash.display.DisplayObject;
	//import flash.display.StageAlign; 
	//import flash.display.StageScaleMode;
	//import flash.utils.getDefinitionByName;
	
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	 
	public class Preloader extends MovieClip{ 
		
		private var model_data:Model;
		private var loading_bar:Loading_bar;
		
		private var bLoaded: uint = loaderInfo.bytesLoaded;
		private var bTotal: uint = loaderInfo.bytesTotal;
		private var Timer_Test:Timer = new Timer(10, 50); //50 
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
			
			 //формула без задержки
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
			
			/* // получаем ссылку на главный класс нашего приложения
			// Метод getDefinitionByName позволяет получить ссылку на класс Scene неявным образом, так что бы этот класс не загружался вместе с классом прелодера
            var mainClass:Class = getDefinitionByName('Scene') as Class;
			
			 // создаем объект главного класса
            var main:DisplayObject = new mainClass(model_data, stage);
            // добавляем его на сцену
            this.parent.addChild(main);
            */
			
			var view:Scene = new Scene(model_data, stage);
			addChild(view);
			
			// удаляем из stage прелодер
            //this.parent.removeChild(this);
		}
		
		

		
	}
}