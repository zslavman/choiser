package
{
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author zslavman
	 */

	
	public class PerLin_Noise extends Sprite{
		
		
		public var oilBitmap:BitmapData;
		public var displacement:DisplacementMapFilter;
		public var MyList:Array; // массив для хранения фильтра displacement
		public var offsets:Array = []; // массив для хранения координаты смещения искажения
		public var filterList:Array = []; // filterList служит контейнером для хранения текущего фильтра клипа “mc”
		public var mc:DisplayObject;
		
		public static var numOctaves:uint = 6; // кл-во октав или индивидуальных функций шума 3

		
		
		
		public function PerLin_Noise(_mc:DisplayObject) {
			
			mc = _mc;
			
			// создаём объект BitmapData с размером сцены, непрозрачный, с чёрной заливкой.
			oilBitmap = new BitmapData(400, 200, false, 0);
			
			/* создаём фильтр DisplacementMapFilter. Он используется для применения эффекта деформации или кратинок к любому объекту,
			   наследуемому от класса DisplayObject, например MovieClip, SimpleButton, TextField и Video, а также к объектам BitmapData.
			
			   DisplacementMapFilter(mapBitmap:BitmapData = null, mapPoint:Point = null, componentX:uint = 0, componentY:uint = 0,
			   scaleX:Number = 0.0, scaleY:Number = 0.0, mode:String = "wrap", color:uint = 0, alpha:Number = 0.0)
			   
			   Параметры
			   mapBitmap:BitmapData (default = null) — Объект BitmapData, содержащий данные карты замещения.
			  
			   mapPoint:Point (default = null) — Значение, содержащее смещение левого верхнего угла целевого экранного объекта из левого
			   верхнего угла изображения карты.
			
			   componentX:uint (default = 0) — Указывает цветовой канал, который следует использовать в изображении карты для замещения 
			   результата x. Возможными значениями являются константы BitmapDataChannel:
			
			   componentY:uint (default = 0) — Указывает цветовой канал, который следует использовать в изображении карты для замещения 
			   результата y. Возможными значениями являются константы BitmapDataChannel:
			
			   scaleX:Number (default = 0.0) — Множитель, с помощью которого масштабируется результат x замещения, полученного в ходе 
			   вычисления карты.
			
			   scaleY:Number (default = 0.0) — Множитель, с помощью которого масштабируется результат y замещения, полученного в ходе 
			   вычисления карты.
			
			   ______
			   mode:String (default = "wrap") — Режим фильтра. Возможными значениями являются константы DisplacementMapFilterMode:
			
			   color:uint (default = 0) — Задает цвет, используемый при смещениях, выходящих за пределы границ. Допустимый диапазон 
			   смещений — от 0,0 до 1,0. Этот параметр используется, если для mode установлено значение DisplacementMapFilterMode.COLOR.
			
			   alpha:Number (default = 0.0) — Задает альфа-значение, используемое при смещениях, выходящих за пределы границ. 
			   Указывается в виде нормализованного значения от 0,0 до 1,0. */
			
			displacement = new DisplacementMapFilter(oilBitmap, new Point(0, 0), 3, 4, 500, 10);
			
			MyList = new Array();
			MyList.push(displacement);
			
			mc.filters = MyList; // применим фильтр к фильтрам клипа “mc”

			// Заполняем массив нулевыми значениями координат Point
			for (var i:uint = 0; i <= numOctaves - 1; i++) {
				offsets.push(new Point());
			}
			
			// Добавляем обработчик события ENTER_FRAME
			this.addEventListener(Event.ENTER_FRAME, enterframe);
		}
		
		
		
		
		public function enterframe(event:Event) {
			// заполняем массив координатами смещения искажения каждый раз увеличивая их по x на 2, по y на 0.25 
			//(это в зависимости от того, куда течёт река.
			for (var i:uint = 0; i <= numOctaves - 1; i++) {
				offsets[i].x += 2;
				offsets[i].y += 0.25;
			}
			
			//Запоминаем текущее состояние фильтров клипа “mc”
			filterList = mc.filters;
			
			// Применяем шум perlinNoise к BitmapData 
			/*
			   perlinNoise(baseX:Number, baseY:Number, numOctaves:uint, randomSeed:int, stitch:Boolean, fractalNoise:Boolean,
			   channelOptions:uint = 7, grayScale:Boolean = false, offsets:Array = null):void
			
			   Параметры
			   baseX:Number — Частота, используемая по оси x. Например, чтобы создать объект с шумом для изображения 
			   размером 64 x 128, передайте 64 для значения baseX.
			
			   baseY:Number — Частота для использования в направлении y. Например, чтобы создать объект с шумом для изображения
			   размером 64 x 128, передайте 128 для значения baseY.
			
			   numOctaves:uint — Количество октав или индивидуальных функций шума, которые необходимо объединить с целью создания шума.
			   Чем больше октав, тем более детальное изображение создается. Также чем больше октав, тем больше времени требуется на обработку.
			
			   randomSeed:int — Начальное значение, используемое для создания случайных чисел. Если не изменять остальных параметров,
			   можно создавать различные псевдослучайные результаты, изменяя начальное значение случайной последовательности. Функция шума
			   Перлина является функцией наложения, а не настоящей функцией создания случайных чисел, поэтому при использовании одного и 
			   того же начального числа она каждый раз дает одинаковые результаты.
			
			   stitch:Boolean — Логическое значение. При значении true метод пытается сгладить края перехода изображения, чтобы создать
			   бесшовную текстуру для мозаичной заливки растровым изображением.
			
			   fractalNoise:Boolean — Логическое значение. При значении true метод создает фрактальный шум, в противном случае создается 
			   турбулентность. Изображение с турбулентностью имеет видимые прерывания градиента, благодаря чему оно больше подходит для более
			   резких визуальных эффектов, например для создания языков пламени или морских волн.
			
			   channelOptions:uint (default = 7) — Число, которое может представлять собой любую комбинацию значений четырех каналов цвета
			   (BitmapDataChannel.RED, BitmapDataChannel.BLUE, BitmapDataChannel.GREEN и BitmapDataChannel.ALPHA). Можно использовать логический
			   оператор ИЛИ (|) для комбинирования значений каналов.
			
			   grayScale:Boolean (default = false) — Логическое значение. При значении true создается изображение с использованием серой шкалы
			   путем присвоения каналам красного, зеленого и синего цветов идентичных значений. Значение альфа-канала остается без изменений, 
			   если данному параметру задано значение true.
			
			   offsets:Array (default = null) — Массив точек, соответствующий смещениям в направлениях x и y для каждой октавы. Изменяя значения 
			   смещения, можно плавно прокручивать слои изображения с шумом Перлина. Каждая точка в массиве смещения применяется к функции шума конкретной октавы.
			 */
			   
			 
			oilBitmap.perlinNoise(500, 3, numOctaves, 55, false, true, 7, true, offsets); // (45, 5, octava, 50, true, false, 7, true, offsets)
			
			// применяем данные карты замещения BitmapData к фильтрам DisplacementMapFilter
			filterList.mapBitmap = oilBitmap;
			
			// Возвращаем клипу “mc” фильтры.
			mc.filters = filterList;	
		}
		
		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, enterframe);
			oilBitmap.dispose();
			oilBitmap = null;
		}
	}
}