
package {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
    import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	public class CustomScroll extends MovieClip{

		private var model:Model;
		private var _stage:Stage; 
		private var _track:MovieClip;
		private var _output:TextField;
		private var _up:SimpleButton;
		private var _down:SimpleButton;
		
		private var dragging:Boolean = false;
		private var position:Number = 0;
		private var rectangle:Rectangle = new Rectangle(0, 0, 0, 0);
		
		
		
		
		public function CustomScroll(stageRef:Stage, track:MovieClip, output:TextField, up:SimpleButton, down:SimpleButton, _model:Model){

			model = _model;
			_stage = stageRef;
			_track = track;
			_output = output;
			_up = up;
			_down = down;
			
			rectangle.height = _track.height;
			_track.knob_mc.y = 0;
			_track.knob_mc.buttonMode = true;
			
			_up.addEventListener(MouseEvent.MOUSE_DOWN, pressTheUpButton);
			_up.addEventListener(MouseEvent.MOUSE_UP, loseUpFocus);
			_up.addEventListener(MouseEvent.MOUSE_OUT, loseUpFocus);
			_down.addEventListener(MouseEvent.MOUSE_DOWN, pressTheDownButton);
			_down.addEventListener(MouseEvent.MOUSE_UP, loseDownFocus);
			_down.addEventListener(MouseEvent.MOUSE_OUT, loseDownFocus);
			_track.knob_mc.addEventListener(MouseEvent.MOUSE_DOWN, dragIt);
			_stage.addEventListener(MouseEvent.MOUSE_UP, dropIt);
			_output.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			
		}
		
		
		
		
		
		/*********************************************
		 *                   Кнопка UP               *
		 *                                           *
		 */ //****************************************
		private function pressTheUpButton(e:MouseEvent):void{
		
			_track.knob_mc.removeEventListener(Event.ENTER_FRAME, adjustIt);
			_track.knob_mc.addEventListener(Event.ENTER_FRAME, holdTheUpButton);
		}
		
		// зажимание кнопки UP
		private function holdTheUpButton(e:Event):void{ 
		
			position = int(position);
			if (position > 0) position -= 1;
			else if (position < 0) position = 0;
			
			_track.knob_mc.y = rectangle.height / (_output.maxScrollV - 1) * position;
			_output.scrollV = position + 1;
			//trace ('p up = ' + position);
		}
		
		// отпускание кнопки UP или MOUSE_OUT
		private function loseUpFocus(e:MouseEvent):void{
			_track.knob_mc.removeEventListener(Event.ENTER_FRAME, holdTheUpButton);
		}
		
		
		/*********************************************
		 *                 Кнопка DOWN               *
		 *                                           *
		 */ //****************************************
		private function pressTheDownButton(e:MouseEvent):void{

			_track.knob_mc.removeEventListener(Event.ENTER_FRAME, adjustIt);
			_track.knob_mc.addEventListener(Event.ENTER_FRAME, holdTheDownButton);
		}
		
		private function holdTheDownButton(e:Event):void{ 

			position = int(position);
			if (position < _output.maxScrollV - 1) position += 1;
			else position = _output.maxScrollV - 1;

			_track.knob_mc.y = rectangle.height / (_output.maxScrollV - 1) * position;
			_output.scrollV = position + 1;
			//trace ('p down = ' + position);
		}
		
		// отпускание кнопки DOWN или MOUSE_OUT
		private function loseDownFocus(e:MouseEvent):void{
			
			_track.knob_mc.removeEventListener(Event.ENTER_FRAME, holdTheDownButton);
		}
		
		
		
		
		
		/*********************************************
		 *                   Бегунок                 *
		 *                                           *
		 */ //****************************************
		private function dragIt(e:MouseEvent):void{
		
			_track.knob_mc.startDrag(false, rectangle);
			dragging = true;
			_track.knob_mc.addEventListener(Event.ENTER_FRAME, adjustIt);
			model.Need_noMOVE = true;
		}
		
		private function dropIt(e:MouseEvent):void{
			
			if (dragging) {
				_track.knob_mc.stopDrag();
				dragging = false;
				model.Need_noMOVE = false;
			}
		}
		

		
		
		/*********************************************
		 *                   Скрол                   *
		 *                                           *
		 */ //****************************************
		private function onWheel(e:MouseEvent):void {
			
			_track.knob_mc.removeEventListener(Event.ENTER_FRAME, adjustIt);
			position += e.delta * -1;
			if (position < 0) {
				position = 0;
			} 
			else if (position > _output.maxScrollV - 1) {
				position = (_output.maxScrollV - 1);
			}
			_track.knob_mc.y = rectangle.height / (_output.maxScrollV - 1) * position;
			//trace ('p wheel = ' + position);
		}
		
		
		
		/*********************************************
		 *                Физика прокрутки           *
		 *                                           *
		 */ //****************************************
		private function adjustIt(e:Event):void {
			
			position = _track.knob_mc.y / (rectangle.height/(_output.maxScrollV - 1));
			if (_track.knob_mc.y >= int(rectangle.height)) {
				position = _output.maxScrollV - 1;
			}
			_output.scrollV = int(position + 1);
			//trace ("model.Need_noMOVE = " + model.Need_noMOVE);
			//trace ('p drag = ' + position);
		}
	}
}