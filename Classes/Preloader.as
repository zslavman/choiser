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
		
		private var bLoaded: uint = loaderInfo.bytesLoaded;
		private var bTotal: uint = loaderInfo.bytesTotal;
		private var Timer_Test:Timer = new Timer(50, 7); //50 
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
			
			var drop: int = 100 * (Timer_Test.currentCount * bLoaded) / (Timer_Test.repeatCount * bTotal);
			if (drop >= 100) loadingFinished();
		}
		
		
		/*********************************************
		 *       Когда вся флешка загрузится         *
		 *                  до 100%                  *
		 */ //****************************************
		
		private function loadingFinished():void {
			
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			Timer_Test.reset();
			
			// удаление желтой рамочки с элементов для листания элементов с клавиатуры
			stage.stageFocusRect = false;

			nextFrame();
			view = new Scene(stage, model_data);
			view.x = 130;
			view.y = 0;
			addChild(view);
		}
	}
}



