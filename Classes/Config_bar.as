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
	
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.*;
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	public class Config_bar extends Sprite {
	
		
		private var model:Model;
		private var myScroll:CustomScroll;
		private var myStage:Stage;
		
		private var key_click:Sound = new _key_click();
		private var chpok:Sound = new _chpok();
		private var mode_count:uint; // номер элемента массива, настройки которого сейчас включены
		
		private var mailCSS:StyleSheet = new StyleSheet();
		
		private var Timer_Press:Timer = new Timer (50); // таймер зажимания кн. сброса

		
		
		
		
		
		public function Config_bar(_data:Model, stage:Stage){ 

			model = _data;	
			myStage = stage;
			
			button_change_mode.addEventListener(MouseEvent.MOUSE_DOWN, mode_MOUSE_DOWN);
			button_change_mode.buttonMode = true;
			
			button_reset.addEventListener(MouseEvent.MOUSE_DOWN, button_reset_MOUSE_DOWN);
			button_reset.buttonMode = true;
			Timer_Press.addEventListener(TimerEvent.TIMER, func_Timer_Press);
			
			about_button.addEventListener(MouseEvent.MOUSE_DOWN, about_button_MOUSE_DOWN);
			about_button.buttonMode = true;
			
			about_scr.addEventListener(MouseEvent.CLICK, about_scr_CLICK);
			
			about_scr.visible = false;
			about_scr.buttonMode = true;
			about_scr.container.mouseChildren = false;
			
			name1.addEventListener(Event.CHANGE, textInputCapture);
			name2.addEventListener(Event.CHANGE, textInputCapture);
			what.addEventListener(Event.CHANGE, textInputCapture);
			
			
			// определение числа mode_count (какой режим включен)
			for (var i:int = 0; i < Animation_kind.length; i++){ 
				if (Animation_kind[i] == Anim_flag) {
					mode_count = i;
				}
			}
			
			if (!MUTE) mute.gotoAndStop('sound_on');
			else mute.gotoAndStop('sound_off');
			
			myScroll = new CustomScroll(myStage, track4_mc, output, up4_btn, down4_btn);
		
			// ф-ция заполнения текстового поля скрола
			scrollertextFill();
				
			// линка с почтой:
			mailCSS.setStyle("a:link", {color:'#000000', textDecoration:'none'}); // 0000CC
			mailCSS.setStyle("a:hover", {color:'#B4FAF9', textDecoration:'underline'}); // 0000FF
			
			about_scr.author.styleSheet = mailCSS;
			about_scr.author.addEventListener(TextEvent.LINK, linkHandler); // слушатель линка в тексте
 
			// заполнение текстовых полей
			TextFill();
			
			reset_level.line.scaleX = 0;
			reset_level.visible = false;
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
			
			reset_txt.text = Phrazes_arr[8];
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
			
			reset_txt.text = Phrazes_arr[8];
			reset_level.visible = false;
			reset_level.line.scaleX = 0;
			
			Anim_flag = 'Вращение';
			Players_names = ['Оля', 'Саша'];
			Verb_arr[2] = '?';
			
			MUTE = false;
			mute.gotoAndStop('sound_on');
			
			Storage = {
				phraza:[],
				cur_date:[],
				cur_time:[]
			};
				
			TextFill();
			output.text = '';
			mode_count = 0;
		}
		
		
		

		
		/*********************************************
		 *         Заполнение текстовых полей        *
		 *                                           *
		 */ //****************************************
		public function TextFill():void{ 
		
			mode.text = Anim_flag;
			name1.text = Players_names[0];
			name2.text = Players_names[1];
			what.text = Verb_arr[2];
			
			about_scr.container.ver.text = Phrazes_arr[10];
			about_scr.container.about_pro.text = Phrazes_arr[11]; 
			about_scr.container.ksiu.text = Phrazes_arr[12];
			about_scr.author.text = Phrazes_arr[13];
			//about_scr.container.author.htmlText = Phrazes_arr[13];
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
			
			if (Storage.phraza.length) {
				
				// прямой порядок вывода инфы
				//for (var i:int = 0; i < Storage.phraza.length; i++){ 
					//toSend += Storage.cur_date[i] + Storage.cur_time[i] + Storage.phraza[i] + '\r';
				//}
				
				// обратный порядок вывода инфы
				for (var i:int = Storage.phraza.length - 1; i >= 0; i--) { 
					toSend += Storage.cur_date[i] + Storage.cur_time[i] + Storage.phraza[i] + '\r';
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
				Players_names[0] = name1.text;
			}
			else if (event.currentTarget.name == 'name2') {
				Players_names[1] = name2.text;
			}
			else if (event.currentTarget.name == 'what') {
				Verb_arr[2] = what.text;
			}
		}
		
		
		
		
		
		/*********************************************
		 *         Кнопка "Режимы вращения"          *
		 *                                           *
		 */ //****************************************
		private function mode_MOUSE_DOWN(event:MouseEvent):void{ 
			
			if (!Spinning_flag){
				key_click.play();
				mode_count++;
				if (mode_count == Animation_kind.length) mode_count = 0;
				Anim_flag = Animation_kind[mode_count];
				mode.text = Anim_flag;
			}
		}
		
	
		
		
		

		
		
		
		/*********************************************
		 *              Кнопка "About"               *
		 *                                           *
		 */ //****************************************
		private function about_button_MOUSE_DOWN(event:MouseEvent):void {
			
			about_scr.visible = true;
			key_click.play();
		}
		
		
		/*********************************************
		 *              Экран "About"                *
		 *                                           *
		 */ //****************************************
		private function about_scr_CLICK(event:MouseEvent):void {
			
			about_scr.visible = false;
		}
		
		
		
		
		
		
		/*********************************************
		 *                 Л и н к и                 *
		 *                                           *
		 */ //****************************************
		public function linkHandler(linkEvent:TextEvent):void {
			
			if (linkEvent.text == "myMail") {
				var myRequest:URLRequest = new URLRequest(Phrazes_arr[14]);
				navigateToURL(myRequest);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *              GETTERS/SETTERS              *
		 *                                           *
		 */ //****************************************
		public function get Phrazes_arr():* {
			return model.phrazes_arr;
		}
		public function set Phrazes_arr(value:*):void {
			model.phrazes_arr = value;
		}
		
		
		
		
		public function get Animation_kind():* {
			return model.animation_kind;
		}

		
		
		public function get Anim_flag():String {
			return model.anim_flag;
		}
		public function set Anim_flag(value:String):void {
			model.anim_flag = value;
			model.SharedObj.data.anim_flag = model.anim_flag;
			model.SharedObj.flush();
		}
		
		
		
		
		public function get Spinning_flag():Boolean {
			return model.spinning_flag;
		}
		
		
		public function get MUTE():Boolean {
			return model.mute_flag;
		}
		public function set MUTE(value:Boolean):void {
			model.mute_flag = value;
			model.SharedObj.data.mute_flag = model.mute_flag;
			model.SharedObj.flush();
		}
		
		
		
		public function get Players_names():* {
			// запись в лок.хранил. из геттера потому что при установке Players_names[x] используется 
			// именно геттер а не сеттер
			model.SharedObj.data.players_names = model.players_names;
			model.SharedObj.flush();
			return model.players_names;
		}
		public function set Players_names(value:*):void {
			model.players_names = value;
			model.SharedObj.data.players_names = model.players_names;
			model.SharedObj.flush();
		}
	
		
	
		public function get Storage():Object {
			model.SharedObj.data.storage = model.storage;
			model.SharedObj.flush();
			return model.storage;
		}
		public function set Storage(value:Object):void {
			model.storage = value;
			model.SharedObj.data.storage = model.storage;
			model.SharedObj.flush();
		}
		
		
		
		
		public function get Verb_arr():* {
			return model.verb_arr;
		}
		//public function set Verb_arr(value:*):void {
			//model.verb_arr = value;
		//}

	}
}