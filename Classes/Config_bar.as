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
	
		
		private var key_click:Sound = new _key_click();
		private var close_config:Tween;
		
		
		
		
		
		public function Config_bar(){ 

			config_bar_off.addEventListener(MouseEvent.MOUSE_DOWN, config_bar_off_MOUSE_DOWN);
			
		}
		
		
		//roleTween2.addEventListener(TweenEvent.MOTION_FINISH, Loop);
		
		
		
		
		
		
		private function config_bar_off_MOUSE_DOWN(e:MouseEvent):void{ 
		
			key_click.play();
			close_config = new Tween (this, 'x', Strong.easeOut, 640, 0, 1, true);
		}
	}
}