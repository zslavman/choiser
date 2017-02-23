/* FrameRater 0.1
 ** Actionscript 3 frame rate meter with graph
 **
 ** Author: Pierluigi Pesenti
 ** http://blog.oaxoa.com
 **
 ** Feel free to use or redistribute but please leave this credits
 */

package
{
	import flash.text.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	public class FrameRater extends Sprite {
		
		private var timer:Timer;
		private var text:TextField;
		private var tf:TextFormat;
		private var c:uint = 0;
		private var dropShadow:DropShadowFilter;
		private var graph:Sprite;
		private var graphBox:Sprite;
		private var graphCounter:uint;
		private var showGraph:Boolean;
		private var graphColor:uint;
		
		public function FrameRater(textColor:uint = 0xFFFFFF, drawShadow:Boolean = false, _showGraph:Boolean = true, _graphColor:uint = 0xFFFFFF) {
			
			this.scaleX = scaleY = 1.5;
			this.alpha = 0;
			
			showGraph = _showGraph;
			graphColor = _graphColor;
			
			if (showGraph) {
				initGraph();
			}
			dropShadow = new DropShadowFilter(1, 90, 0, 1, 2, 2);
			tf = new TextFormat();
			tf.color = textColor;
			tf.font = "_sans";
			tf.size = 11;
			text = new TextField();
			text.width = 100;
			text.height = 20;
			text.x = 3;
			text.selectable = false;
			if (drawShadow)	text.filters = [dropShadow];
			
			addChild(text);
			
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			this.addEventListener(MouseEvent.MOUSE_DOWN, fps_MOUSE_DOWN);
		}
		
		
		
		
		
		private function fps_MOUSE_DOWN(e:MouseEvent):void{ 
		
			if (this.alpha == 0) this.alpha = 1;
			else this.alpha = 0;
			
		}
		
		

		private function onTimer(event:TimerEvent):void {
			var val:Number = computeTime();
			text.text = Math.floor(val).toString() + " fps";
			text.setTextFormat(tf);
			text.autoSize = "left";
			if (showGraph) {
				updateGraph(val);
			}
		}
		
		private function onFrame(event:Event):void {
			c++;
		}
		
		public function computeTime():Number {
			var retValue:uint = c;
			c = 0;
			return retValue * 2 - 1;
		
		}
		
		public function updateGraph(n:Number):void {
			if (graphCounter > 30) {
				graph.x--;
			}
			graphCounter++;
			graph.graphics.lineTo(graphCounter, 1 + (stage.frameRate - n) / 3);
		}
		
		private function initGraph():void {
			graphCounter = 0;
			graph = new Sprite();
			graphBox = new Sprite();
			graphBox.graphics.beginFill(0xff0000);
			graphBox.graphics.drawRect(0, 0, 36, 100);
			graphBox.graphics.endFill();
			graph.mask = graphBox;
			graph.x = graphBox.x = 5;
			graph.y = graphBox.y = 20;
			graph.graphics.lineStyle(1, graphColor);
			
			addChild(graph);
			addChild(graphBox);
		}
	}
}