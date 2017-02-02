package 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.Sound;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.*;
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	public class Config_bar extends Sprite {
	
		
		private var data:Model;
		private var myScroll:CustomScroll;
		private var myStage:Stage;
		
		
		private var key_click:Sound = new _key_click();
		private var mode_count:uint; // номер элемента массива, настройки которого сейчас включены
		
		private var mailCSS:StyleSheet = new StyleSheet();

		
		
		
		
		
		public function Config_bar(_data:Model, stage:Stage){ 

			data = _data;	
			myStage = stage;
			
			button_change_mode.addEventListener(MouseEvent.MOUSE_DOWN, mode_MOUSE_DOWN);
			button_change_mode.buttonMode = true;
			mute.addEventListener(MouseEvent.MOUSE_DOWN, mute_MOUSE_DOWN);
			mute.buttonMode = true;
			
			about_button.addEventListener(MouseEvent.MOUSE_DOWN, about_button_MOUSE_DOWN);
			about_button.buttonMode = true;
			
			about_scr.addEventListener(MouseEvent.CLICK, about_scr_CLICK);
			
			about_scr.visible = false;
			about_scr.buttonMode = true;
			about_scr.container.mouseChildren = false;
			
			name1.addEventListener(Event.CHANGE, textInputCapture);
			name2.addEventListener(Event.CHANGE, textInputCapture);
			
			
			// определение числа mode_count (какой режим включен)
			for (var i:int = 0; i < Animation_kind.length; i++){ 
				if (Animation_kind[i] == Anim_flag) {
					mode_count = i;
				}
			}
			
			myScroll = new CustomScroll(myStage, track4_mc, output, up4_btn, down4_btn);
		
			// ф-ция заполнения текстового поля скрола
			scrollertextFill();
				
			if (!MUTE) mute.gotoAndStop('sound_on');
			else mute.gotoAndStop('sound_off');

			// линка с почтой:
			mailCSS.setStyle("a:link", {color:'#000000', textDecoration:'none'}); // 0000CC
			mailCSS.setStyle("a:hover", {color:'#B4FAF9', textDecoration:'underline'}); // 0000FF
			
			about_scr.author.styleSheet = mailCSS;
			about_scr.author.addEventListener(TextEvent.LINK, linkHandler); // слушатель линка в тексте
 
			// заполнение текстовых полей
			TextFill();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *         Заполнение скролового текста      *
		 *                                           *
		 */ //****************************************
		private function scrollertextFill():void { 
			
			//storage = {
				//phraza:[],
				//cur_date:[],
				//cur_time:[]
			//}
			
			var toSend:String;
			
			for (var i:int = 0; i < Storage.phraza.length; i++){ 
				toSend += Storage.phraza[i] + Storage.cur_date[i] + Storage.cur_time[i] + '\r';
			}
			output.text = toSend;
		}
		
		
		
		
		
		/*********************************************
		 *         Заполнение текстовых полей        *
		 *                                           *
		 */ //****************************************
		private function TextFill():void{ 
		
			mode.text = Anim_flag;
			name1.text = Players_names[0];
			name2.text = Players_names[1];
			
			about_scr.container.ver.text = Phrazes_arr[10];
			about_scr.container.about_pro.text = Phrazes_arr[11]; 
			about_scr.container.ksiu.text = Phrazes_arr[12];
			about_scr.author.text = Phrazes_arr[13];
			//about_scr.container.author.htmlText = Phrazes_arr[13];
		}
		
		
		
		/*********************************************
		 *         Захват введенного текста          *
		 *                                           *
		 */ //****************************************
		private function textInputCapture(event:Event):void{ 
			
			if (event.currentTarget.name == 'name1') {
				Players_names[0] = name1.text;
			}
			else Players_names[1] = name2.text;

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
		 *              Кнопка "MUTE"                *
		 *                                           *
		 */ //****************************************
		private function mute_MOUSE_DOWN(event:MouseEvent):void {
		
			key_click.play();
			
			if (MUTE) {
				MUTE = false;
				mute.gotoAndStop('sound_on');
			}
			else {
				MUTE = true;
				mute.gotoAndStop('sound_off');
			}
		}
		
		
		
		/*********************************************
		 *              Кнопка "About"               *
		 *                                           *
		 */ //****************************************
		private function about_button_MOUSE_DOWN(event:MouseEvent):void {
			
			about_scr.visible = true;
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
			return data.phrazes_arr;
		}
		public function set Phrazes_arr(value:*):void {
			data.phrazes_arr = value;
		}
		
		
		
		
		public function get Animation_kind():* {
			return data.animation_kind;
		}

		
		
		public function get Anim_flag():String {
			return data.anim_flag;
		}
		public function set Anim_flag(value:String):void {
			data.anim_flag = value;
		}
		
		
		
		
		public function get Spinning_flag():Boolean {
			return data.spinning_flag;
		}
		
		
		
		
		public function get Players_names():* {
			return data.players_names;
		}
		public function set Players_names(value:*):void {
			data.players_names = value;
		}
		
		
		
		
		public function get MUTE():Boolean {
			return data.mute_flag;
		}
		public function set MUTE(value:Boolean):void {
			data.mute_flag = value;
		}
		
		
		
		public function get Storage():Object {
			return data.storage;
		}
		public function set Storage(value:Object):void {
			data.storage = value;
		}

	}
}