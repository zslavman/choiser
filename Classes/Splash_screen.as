package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	public class Splash_screen extends Sprite {
		
		
		private var model:Model;
		private var phrazes_arr:Array = [];
		private var key_click:Sound = new _key_click();
		
		
		
		
		public function Splash_screen(_model:Model) {
			
			model = _model;
			phrazes_arr = Model.Phrazes_arr;
		
			name1.addEventListener(Event.CHANGE, textInputCapture);
			name2.addEventListener(Event.CHANGE, textInputCapture);
			ok_button.addEventListener(MouseEvent.CLICK, ok_button_CLICK);
			ok_button.buttonMode = true;
			
			textFill();
			
		}
	
		
		
		

		
		
		/*********************************************
		 *                 Кнопка "OK"               *
		 *                                           *
		 */ //****************************************
		public function ok_button_CLICK(event:MouseEvent):void {
		
			key_click.play();
			
			model.First_time = false;
			parent.removeChild(this);
		}
		
		
		
		/*********************************************
		 *         Заполнение текстовых полей        *
		 *                                           *
		 */ //****************************************
		public function textFill():void {
			
			adge.text = phrazes_arr[15];
			ver.text = phrazes_arr[10];
			about_pro1.text = phrazes_arr[11]; 
			about_pro2.text = phrazes_arr[30]; 
			enter_names.text = phrazes_arr[31];
			
			name1.text = model.Players_names[0];
			name2.text = model.Players_names[1];

		}
		
		
		
		

		/*********************************************
		 *         Захват введенного текста          *
		 *                                           *
		 */ //****************************************
		private function textInputCapture(event:Event):void{ 
			
			if (event.currentTarget.name == 'name1') {
				if (name1.text.length > 11) cuterStr(11, name1);
				model.Players_names[0] = name1.text;
			}
			else if (event.currentTarget.name == 'name2') {
				if (name2.text.length > 11) cuterStr(11, name2);
				model.Players_names[1] = name2.text;
			}
		}
		
		
		
		
		
		private function cuterStr(len:uint, txt:*):void {
			txt.text = txt.text.slice(0, len);
		}
		
		
		
		
		
		
		
		
		
	}
}