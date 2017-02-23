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
		private var frame:uint = 0;
		private var items:Array = [];
		private var W:Number;
	
		
		public function Fountain(_W:Number, H:Number){
		
			W = _W;
			
			// создание маски для экрана настроек
			maska = new Sprite();
			maska.graphics.beginFill(0x000000, 1);
			maska.graphics.drawRect(0, 0, W, H);
			maska.graphics.endFill();
			addChild(maska);
			this.mask = maska;
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			addEventListener(Event.ENTER_FRAME, beam);
		}
		
		
		
		
		
		

		/*********************************************
		 *               Создает частицы             *
		 *                                           *
		 */ //****************************************
		private function beam(event: Event) {

			frame++;
			
			if (frame == 14) {
				frame = 0;
				
				var spray:MovieClip = new Fountain_particle();
				spray.x = Math.random() * W;
				spray.y = 1200; 
	
				// задание свойства созданого объекта (уравнения прямых)
				spray.mov_x = 3 * Math.random() - 1.5;
				spray.mov_y = 1 * Math.random() + 2; //5
	
				spray.alpha = Math.random() * Math.random() + 0.75;
				spray.width = spray.height = 25 + Math.random() * 50;
				
				// добавляем в массив, для дальнейшего удаления слушателя каждой частицы
				items.push(spray);
				
				addChild(spray);
				
				//trace ("items = " + items);
	
				// создаем энтер_фрейм для каждой добавленной на сцену частицы.
				spray.addEventListener(Event.ENTER_FRAME, Propagation);
			}

		}


		
		
		

		/*********************************************
		 *               Двигает частицы             *
		 *                                           *
		 */ //****************************************
		private function Propagation(event: Event) {
			
			//trace ("numChildren = " + numChildren);
			
			var particle: MovieClip;
				
			particle = event.currentTarget as MovieClip;
				
			particle.x = particle.x - particle.mov_x;
			particle.y = particle.y - particle.mov_y;
	
			//if (particle.y < 400) {
				//particle.alpha -= 0.02;
				//particle.scaleX += 0.02;
				//particle.scaleY += 0.02;
			//}

			// уничтожение частиц
			if (particle.y < -10) {
				particle.removeEventListener(Event.ENTER_FRAME, Propagation);
				particle.parent.removeChild(particle);
				particle = null;
			}
		}

	
		
		
		public function destroy():void {
		
			removeEventListener(Event.ENTER_FRAME, beam);
			
			if (items.length) {
				for (var i:int = 0; i < items.length; i++){ 
				items[i].removeEventListener(Event.ENTER_FRAME, Propagation);
				}
			}
			// очистка класса от всех потомков
			while (numChildren > 0) removeChildAt(0);
		}
		
		
		
		
		
	}
}