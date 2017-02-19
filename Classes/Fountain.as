package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	public class Fountain extends MovieClip {
	
		private var maska:Sprite;
		
		private var temp:uint = 0;
		private var temp1:uint = 0;
		private var temp2:uint = 0;
		
		
	
		
		public function Fountain(){
		
			
			// создание маски для экрана настроек
			maska = new Sprite();
			maska.graphics.beginFill(0x000000, 1);
			maska.graphics.drawRect(0, 0, 640, 1136);
			maska.graphics.endFill();
			addChild(maska);
			this.mask = maska;
			
			addEventListener(Event.ENTER_FRAME, beam);
		}
		
		
		
		
		
		

		
		private function beam(event: Event) {

			var spray = new spray_mc();

			spray.x = Math.random() * 640;
			//spray.x = 600;
			spray.y = 1136; 

			// создание свойства созданного объекта (уравнения прямых)
			spray.mov_x = 3 * Math.random() - 1.5;
			spray.mov_y = 1 * Math.random() + 2; //5

			spray.alpha = Math.random() * Math.random() + 0.5;
			spray.width = spray.height = 6 + Math.random() * 40;
			//spray.mouseEnabled = false;
			addChild(spray);

			// создаем обработчик события ентер_фрейм для каждой добавленной на сцену капли.
			spray.addEventListener(Event.ENTER_FRAME, radio_Wave_Propagation);
		}



		private function radio_Wave_Propagation(event: Event) {

			var particle: MovieClip = event.currentTarget as MovieClip;

			particle.x = particle.x - particle.mov_x;
			particle.y = particle.y - particle.mov_y;

			//if (particle.y < 800) {
				//particle.alpha -= 0.02;
				//particle.scaleX += 0.02;
				//particle.scaleY += 0.02;
			//}

			// уничтожение частиц
			if (particle.y < -10) {
				particle.removeEventListener(Event.ENTER_FRAME, radio_Wave_Propagation);
				removeChild(particle);
				particle = null;
			}
		}

	
		
		
		public function destroy():void {
		
			removeEventListener(Event.ENTER_FRAME, beam);
		}
		
		
		
		
		
	}
}