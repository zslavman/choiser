package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	public class Config_bar extends Sprite {
	
		
		private var data:Model;
		
		
		private var key_click:Sound = new _key_click();
		private var mode_count:uint; // номер элемента массива, настройки которого сейчас включены
		

		
		
		
		
		
		public function Config_bar(_data){ 

			data = _data;	
			
			button_change_mode.addEventListener(MouseEvent.MOUSE_DOWN, mode_MOUSE_DOWN);
			mode.text = Anim_flag;
			
			// определение числа mode_count
			for (var i:int = 0; i < Animation_kind.length; i++){ 
				if (Animation_kind[i] == Anim_flag) {
					mode_count = i;
				}
			}
			trace ("mode_count = " + mode_count); 

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
		
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function get Animation_kind():* {
			return data.animation_kind;
		}
		//public function set Animation_kind(value:uint):void {
			//data.animation_kind = value;
		//}
		
		
		public function get Anim_flag():String {
			return data.anim_flag;
		}
		public function set Anim_flag(value:String):void {
			data.anim_flag = value;
		}
		
		
		public function get Spinning_flag():Boolean {
			return data.spinning_flag;
		}

	}
}