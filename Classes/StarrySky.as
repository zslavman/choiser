package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	
	
	
	public class StarrySky extends Sprite {
		
		public static const BASE = 10; // размер частей шума
		public static const OCTS = 4; // кол-во слоев шума
		private var blurFilter:BlurFilter;
		
		
		
		public function StarrySky(w:uint, h:uint) {

			var stars:BitmapData = new BitmapData(w, h);
			
			// наложение шума на созданную выше битмапдата
			stars.perlinNoise(BASE, BASE, OCTS, Math.random()*1000, true, true, 1, true);
			
			// удаление всего кроме самых светлых пикселей (фильтруем шум)
			stars.threshold(stars, 						// пиксели для проверки
							new Rectangle(0, 0, w, h), 	// область для проверки
							new Point(),				// позиция прямоугольника
							"<",						// оператор с которым осуществлять проверку
							0xDDDDDD,					// значение срабатывания "фильтра"
							0,							// цвет которым нужно заменять
							0xFFFFFF,					// цвет маски (для всех в этом случае)
							true);						// Копировать оринигал пикселей в случае ошибки?
			
			// Создание битмап объекта для отображения звезд 
			var starsBitmap:Bitmap = new Bitmap(stars);
			addChild(starsBitmap);
			
			blurFilter = new BlurFilter();
			blurFilter.blurX = blurFilter.blurY = 1.4;
			blurFilter.quality = 3;

			// наложение фильтра
			starsBitmap.filters = [blurFilter];
		}
	}
}