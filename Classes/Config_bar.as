package 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.utils.Timer;
	
	import flash.filters.BlurFilter;
	

	
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	public class Config_bar extends Sprite {
	
		public var about_scr	:About;
		private var fountain	:Fountain;
		private var model		:Model;
		private var myScroll	:CustomScroll;
		private var myStage		:Stage;
		private var mask_about	:Sprite;
		
		private var key_click:Sound = new _key_click();
		private var chpok:Sound = new _chpok();
		private var mode_count:uint; // номер элемента массива, настройки которого сейчас включены
		
		private var Timer_Press:Timer = new Timer (50); // таймер зажимания кн. сброса
		
		private var blurFilter:BlurFilter;
		
		private var phrazes_arr:Array = [];
		private var words_count:uint = 1; // число для листания слов
		private var selector_flag:Boolean = false; // флаг для определения что выводить (глагол или имя существ.) 

		
		
		
		
		
		public function Config_bar(_data:Model, stage:Stage){ 

			model = _data;	
			myStage = stage;
			phrazes_arr = Model.Phrazes_arr;
			
			button_change_mode.addEventListener(MouseEvent.MOUSE_DOWN, mode_MOUSE_DOWN);
			button_change_mode.buttonMode = true;
			
			chg_up.addEventListener(MouseEvent.MOUSE_DOWN, chg_MOUSE_DOWN);
			chg_up.buttonMode = true;
			
			chg_down.addEventListener(MouseEvent.MOUSE_DOWN, chg_MOUSE_DOWN);
			chg_down.buttonMode = true;
			
			button_reset.addEventListener(MouseEvent.MOUSE_DOWN, button_reset_MOUSE_DOWN);
			button_reset.buttonMode = true;
			Timer_Press.addEventListener(TimerEvent.TIMER, func_Timer_Press);
			
			about_button.addEventListener(MouseEvent.MOUSE_DOWN, about_button_MOUSE_DOWN);
			about_button.buttonMode = true;
			
			
			name1.addEventListener(Event.CHANGE, textInputCapture);
			name2.addEventListener(Event.CHANGE, textInputCapture);
			what.addEventListener(Event.CHANGE, textInputCapture);
			
			
			// определение числа mode_count (какой режим включен)
			for (var i:int = 0; i < model.Animation_kind.length; i++){ 
				if (model.Animation_kind[i] == model.Anim_flag) {
					mode_count = i;
				}
			}
			
			if (!model.MUTE) mute.gotoAndStop('sound_on');
			else mute.gotoAndStop('sound_off');
			
			// Добавление класса Скрола текстового поля
			myScroll = new CustomScroll(myStage, track4_mc, output, up4_btn, down4_btn, model);
		
			// ф-ция заполнения текстового поля скрола
			scrollertextFill();
				
			// заполнение текстовых полей
			TextFill();
			
			reset_level.line.scaleX = 0;
			reset_level.visible = false;
		}
		

		

		
		
		
		
		
		
		/*********************************************
		 *                Кнопка "Chg"               *
		 *                                           *
		 */ //****************************************
		private function chg_MOUSE_DOWN(event:MouseEvent):void {
			
			key_click.play();
			
			if (event.currentTarget.name == 'chg_down') {
				words_count--;
				if (words_count < 1) {
					words_count = model.Verb_arr.length - 1;
					selector_flag = !selector_flag;
				}
			}
			else if (event.currentTarget.name == 'chg_up') {
				words_count++;
				if (words_count > model.Verb_arr.length - 1) {
					words_count = 1;
					selector_flag = !selector_flag;
				}
			}
			
			if (selector_flag) {
				what.text = model.Verb_arr[words_count];
				glagol.text = phrazes_arr[28] + ' ' + words_count;
			}
			else {
				what.text = model.Words_arr[words_count];
				glagol.text = phrazes_arr[29] + ' ' + words_count;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *                Кнопка "RESET"             *
		 *                                           *
		 */ //****************************************
		private function button_reset_MOUSE_DOWN(event:MouseEvent):void {
			
			button_reset.addEventListener(MouseEvent.MOUSE_OUT, button_reset_MOUSE_UP_OUT);
			button_reset.addEventListener(MouseEvent.MOUSE_UP, button_reset_MOUSE_UP_OUT);
			Timer_Press.start();
			key_click.play();
			reset_txt.text = '';
			reset_level.visible = true;
			
		}
		private function button_reset_MOUSE_UP_OUT(event:MouseEvent):void {
			
			button_reset.removeEventListener(MouseEvent.MOUSE_OUT, button_reset_MOUSE_UP_OUT);
			button_reset.removeEventListener(MouseEvent.MOUSE_UP, button_reset_MOUSE_UP_OUT);
			
			reset_txt.text = phrazes_arr[8];
			reset_level.visible = false;
			reset_level.line.scaleX = 0;
			
			Timer_Press.reset();
		}

		
		
		/*********************************************
		 *           Таймер зажимания кнопки         *
		 *                  "RESET"                  *
		 */ //****************************************
		private function func_Timer_Press(event:TimerEvent):void{ 

			reset_level.line.scaleX = Timer_Press.currentCount / 50;
			
			if (Timer_Press.currentCount == 50) {
				Timer_Press.reset();
				Load_default();
			}
			
		}
		
		private function Load_default():void{ 

			chpok.play();
			
			reset_txt.text = phrazes_arr[8];
			reset_level.visible = false;
			reset_level.line.scaleX = 0;
			
			//model.Players_names = [phrazes_arr[4], phrazes_arr[5]];
			model.Anim_flag = model.Animation_kind[0];
			model.First_time = true;
			
			model.MUTE = false;
			mute.gotoAndStop('sound_on');
			
			model.Storage = {
				phraza:[],
				cur_date:[],
				cur_time:[]
			};
				
			Recovery_array(model.Words_arr, model.Words_arr_reserve);
			Recovery_array(model.Verb_arr, model.Verb_arr_reserve);
			words_count = 1;
			selector_flag = false;
			TextFill();
			output.text = '';
			mode_count = 0;
	
		}
		
		
		// ф-ция восстанавливающая массивы из резерва
		private function Recovery_array(destination:Array, from:Array):void {
			
			for (var i:int = 0; i < destination.length; i++){ 
				var temp:String = from[i];
				destination[i] = temp;
			}
		}
		
		

		
		/*********************************************
		 *         Заполнение текстовых полей        *
		 *                                           *
		 */ //****************************************
		public function TextFill():void{ 
		
			mode.text = model.Anim_flag;
			name1.text = model.Players_names[0];
			name2.text = model.Players_names[1];
			what.text = model.Words_arr[1];
			glagol.text = phrazes_arr[29] + ' ' + words_count;
		}
		
		
		
		
		
		
		/*********************************************
		 *         Заполнение скроллер поля          *
		 *                                           *
		 */ //****************************************
		public function scrollertextFill():void{ 

			//storage = {
				//phraza:[],
				//cur_date:[],
				//cur_time:[]
			//}
			
			var toSend:String = '';
			
			if (model.Storage.phraza.length) {
				
				// прямой порядок вывода инфы
				//for (var i:int = 0; i < Storage.phraza.length; i++){ 
					//toSend += Storage.cur_date[i] + Storage.cur_time[i] + Storage.phraza[i] + '\r';
				//}
				
				// обратный порядок вывода инфы
				//for (var i:int = model.Storage.phraza.length - 1; i >= 0; i--) { 
					//toSend += model.Storage.cur_date[i] + model.Storage.cur_time[i] + model.Storage.phraza[i] + '\r';
				//}
				
				// быстрый способ обойти массив с конца
				var i:uint = model.Storage.phraza.length;
				while(i--) {
					toSend += model.Storage.cur_date[i] + model.Storage.cur_time[i] + model.Storage.phraza[i] + '\r';
				}
				output.text = toSend;
			}
		}
		
		
		
		
		
		

		/*********************************************
		 *         Захват введенного текста          *
		 *                                           *
		 */ //****************************************
		private function textInputCapture(event:Event):void{ 
			
			if (event.currentTarget.name == 'name1') {
				if (name1.text.length > 11) {
					//name1.text = name1.text.slice(0, 11);
					cuterStr(11, name1);
				}
				model.Players_names[0] = name1.text;
			}
			else if (event.currentTarget.name == 'name2') {
				if (name2.text.length > 11) cuterStr(11, name2);
				model.Players_names[1] = name2.text;
			}
			else if (event.currentTarget.name == 'what') {
			
				if (selector_flag) {
					model.Verb_arr[words_count] = what.text;
					if (what.text.length > 10) cuterStr(10, what);
				}
				else {
					if (what.text.length > 8) cuterStr(8, what);
					model.Words_arr[words_count] = what.text;
				}
				
				//var temp_arr:Array = model.Verb_arr;
				//temp_arr[words_count] = what.text;
				//model.Verb_arr = temp_arr;
				//trace ("temp_arr = " + temp_arr);
			}
		}
		
		
		
		private function cuterStr(len:uint, txt:*):void {
			txt.text = txt.text.slice(0, len);
		}
		
		
		
		
		
		/*********************************************
		 *         Кнопка "Режимы вращения"          *
		 *                                           *
		 */ //****************************************
		private function mode_MOUSE_DOWN(event:MouseEvent):void{ 
			
			if (!model.Spinning_flag){
				key_click.play();
				mode_count++;
				if (mode_count == model.Animation_kind.length) mode_count = 0;
				model.Anim_flag = model.Animation_kind[mode_count];
				mode.text = model.Anim_flag;
			}
		}
		
	
		
		
		

		
		
		
		/*********************************************
		 *              Кнопка "About"               *
		 *                                           *
		 */ //****************************************
		private function about_button_MOUSE_DOWN(event:MouseEvent):void {
			
			about_scr = new About();
			about_scr.addEventListener(MouseEvent.CLICK, about_scr_CLICK);
			parent.addChild(about_scr);
			Blur('forward');
			
			fountain = new Fountain();
			parent.addChild(fountain);
			
			
			// создание маски для экрана 'О программе'
			mask_about = new Sprite();
			mask_about.graphics.beginFill(0x000000, 1);
			mask_about.graphics.drawRect(0, 0, 640, 1136);
			mask_about.graphics.endFill();
			parent.addChild(mask_about);
			parent.mask = mask_about;
			
			key_click.play();
		}
		
		
		
		/*********************************************
		 *              Экран "About"                *
		 *                                           *
		 */ //****************************************
		private function about_scr_CLICK(event:MouseEvent):void {
			
			about_scr.removeEventListener(MouseEvent.CLICK, about_scr_CLICK);
			parent.removeChild(about_scr);
			parent.removeChild(mask_about);
			fountain.destroy();
			parent.removeChild(fountain);
			mask_about = null;
			about_scr = null;
			fountain = null;
			
			Blur('revers');
		}
		
		
		
		
		
		public function Blur(direction:String):void {
			
			// прямое направление
			if (direction == 'forward') {
				
				blurFilter = new BlurFilter();
				blurFilter.blurX = blurFilter.blurY = 16;
				blurFilter.quality = 3;
				
				// наложение фильтров
				this.filters = [blurFilter];
			}

			// обратное направление
			else if (direction == 'revers') {

				// снятие фильтров
				this.filters = null;
			}
		}
	}
}