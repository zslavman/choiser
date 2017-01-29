package 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	public class Scene extends Sprite {
	
		private var data:Model;
		
		private var roleTween:Tween;
		private var lineStart_y;
		
		private var tween_duration:Number = 0.1;
		
		private var circles:uint = 1; // начало с 1 т.к. в массиве слов первое (нулевое) значение не учитывается
		private var clicker:Sound = new _clicker();
		private var wheel_sound:Sound = new _wheel_sound();
		private var wheel_sound_double:Sound = new _wheel_sound_double();
		
		private var rot_duration:Number = 3000; // мс
		private var Timer_DurationRot:Timer = new Timer(250);
		private var Timer_Listing:Timer = new Timer(80);
		
		
	
		
		
		
		
		public function Scene(stage2, model_data) { 
			
			data = model_data;
		
			button1.addEventListener(MouseEvent.MOUSE_DOWN, button1_MOUSE_DOWN);
			Timer_DurationRot.addEventListener(TimerEvent.TIMER, func_Timer_DurationRot);
			Timer_Listing.addEventListener(TimerEvent.TIMER, func_Timer_Listing);
			lineStart_y = line_short1.y;
			
			line_short1.w1.text = Phrazes_arr[2]; // Сделать
			//line_short1.w2.text = Words_arr[2];
			
			line_short2.w1.text = Phrazes_arr[3]; // что-то :)
			//line_short2.w2.text = Words_arr[2];
			
			
			statusbar.text = Phrazes_arr[0];
		}
		
	
	
		
		/*********************************************
		 *              Таймер длительности          *
		 *                 анимации слов             *
		 */ //****************************************
		private function func_Timer_DurationRot(event:TimerEvent):void{ 
			
			if (Timer_DurationRot.currentCount >= 8) {
				tween_duration += 0.2;
			}
			if (Timer_DurationRot.currentCount > 9) {
				Timer_Listing.delay += 25;	
			}
			
			if (Timer_DurationRot.currentCount == rot_duration/Timer_DurationRot.delay) { // 12
				stopMoove();
			}
			
		}
		
		/*********************************************
		 *              Таймер листания слов         *
		 *                                           *
		 */ //****************************************
		private function func_Timer_Listing(event:TimerEvent):void { 
			
			if (spinning_flag) {
				circles++;
				wheel_sound.play();
				if (circles == Words_arr.length) circles = 1;
				line_short1.w1.text = Words_arr[circles];
				line_short1.w2.text = Words_arr[circles];
			}
		}
		
		
		
		
		
		
		
		/*********************************************
		 *              Кнопка "Пуск/Стоп"           *
		 *                                           *
		 */ //****************************************
		public function button1_MOUSE_DOWN(event:MouseEvent):void {
			
			if (!spinning_flag) {
				spinning_flag = true;
				statusbar.text = Phrazes_arr[1];
				
				// запуск случайной сортировки массива:
				SortMe();
				
				Timer_DurationRot.start();
				if (!rotation_flag) startMoove(); // запуск твина вращения слов
				else Timer_Listing.start(); // запуск перебора слов (слова будут просто перечисляться по таймеру)
			}
		}
		
		
		
		
		
		/*********************************************
		 *          Остановка вращения колеса        *
		 *                                           *
		 */ //****************************************
		public function stopMoove():void{ 
		
			Timer_DurationRot.reset();
			spinning_flag = false;
			statusbar.text = Phrazes_arr[0];
			
			tween_duration = 0.1;
			Timer_Listing.delay = 80;
			//stopMoove(); // твин доходит до цикла след. запуска и останавливается
		}
		
		
		/*********************************************
		 *             Твин вращения колеса          *
		 *                                           *
		 */ //****************************************
		public function startMoove():void {
		
			roleTween = new Tween (line_short1, 'y', None.easeInOut, lineStart_y, lineStart_y + 47, tween_duration, true);
			roleTween.addEventListener(TweenEvent.MOTION_FINISH, Loop);
		}
		
		
		/*********************************************
		 *       Зацикливание вращения колеса        *
		 *                                           *
		 */ //****************************************
		public function Loop(event:TweenEvent):void {
			
			roleTween.removeEventListener(TweenEvent.MOTION_FINISH, Loop);
			
			//wheel_sound_double.play();
			wheel_sound.play();
			
			if (spinning_flag) {
				circles++;
	
				// запись в первое поле
				line_short1.w1.text = Words_arr[circles];
				
				if (circles == Words_arr.length - 1) circles = 0;

				// запись во второе поле
				line_short1.w2.text = Words_arr[circles + 1];
				
				startMoove();
			}
			else { // если остановлено
				// выпавшее слово всегда будет находиться во 2-й текст. ячейке,
				// т.к. остановка происходит лишь после доезда до финиша
			}
		}
		

		

		
		
		/*********************************************
		 *              Случайная сортировка         *
		 *                   массива                 *
		 */ //****************************************
		private function SortMe():void { 
			
			trace (line_short1.w2.text);
			
			Words_arr.sort(randomSortFunc);
			// перемещение элемента 'not used' на 0-е место:
			Words_arr = replaceNotUsed(data.words_arr);
			trace (Words_arr);
		}
		 
		 private function randomSortFunc(a, b):Number {
			return Math.random() - 0.5;
		}
		
		
		
		
		private function replaceNotUsed(array:Array):Array{ 

			for (var i:int = 0; i < array.length; i++){ 
				if (array[i] == 'not used') {
					
					// перемещение метод 1:
					//array.splice(i, 1); // удаляем найденный элемент массива
					//array.unshift('not used'); // добавляем элемент в начало массива
					
					// перемещение метод 2:
					var temp:String = array[0];
					array[i] = temp;
					array[0] = 'not used';
				}
			}
			return array;
		}
		
		
		
		
		
		
		
		/*********************************************
		 *              GETTERS/SETTERS              *
		 *                                           *
		 */ //****************************************
		public function get Words_arr():* {
			return data.words_arr;
		}
		public function set Words_arr(value:*):void {
			data.words_arr = value;
		}
		
		
		public function get Phrazes_arr():* {
			return data.phrazes_arr;
		}
		public function set Phrazes_arr(value:*):void {
			data.phrazes_arr = value;
		}
		
		
		public function get spinning_flag():Boolean {
			return data.spinning_flag;
		}
		public function set spinning_flag(value:Boolean):void {
			data.spinning_flag = value;
		}
		
		
		public function get rotation_flag():Boolean {
			return data.rotation_flag;
		}
		public function set rotation_flag(value:Boolean):void {
			data.rotation_flag = value;
		}
		
	}
}