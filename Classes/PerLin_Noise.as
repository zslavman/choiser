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
		
		
		public static var numOctaves:uint = 10; // кл-во октав или индивидуальных функций шума 3
		
		internal var waterBitmap	:BitmapData;
		internal var displacement	:DisplacementMapFilter;
		internal var myList			:Array; // массив для хранения фильтра displacement
		internal var offsets		:Array = []; // массив для хранения координаты смещения искажения
		internal var filterList		:Array = []; // filterList служит контейнером для хранения текущего фильтра клипа “mc”
		internal var mc				:DisplayObject;
		internal var waweX:uint;
		internal var waweY:uint;

		
		
		
		public function PerLin_Noise(_mc:DisplayObject, w:uint, h:uint, _waweX:uint, _waweY:uint, scalX:uint = 500, scalY:uint = 5) {
			
			mc = _mc;
			waweX = _waweX;
			waweY = _waweY;
			myList = new Array();
			
			// создаём объект BitmapData
			waterBitmap = new BitmapData(w, 	// высота BitmapData
										h, 		// ширина BitmapData 
										false,  // заливка прозрачная?
										0); 	// цвет заливки (черный)
			
			// создаём фильтр DisplacementMapFilter
			displacement = new DisplacementMapFilter(waterBitmap,  	// Объект BitmapData, содержащий данные карты замещения.  
													new Point(0, 15),// Значение, содержащее смещение левого верхнего угла целевого экранного объекта из левого верхнего угла изображения карты
													3, 				// Указывает цветовой канал, который следует использовать в изображении карты для замещения  результата x. Возможными значениями являются константы BitmapDataChannel
													4, 	 			// тоже самое для 'y'
													scalX,			// Множитель, с помощью которого масштабируется результат 'x' замещения, полученного в ходе вычисления карты
													scalY, 			// тоже самое для 'y'
													'wrap', 		// ДАЛЕЕ ИДУТ НЕОБЯЗАТЕЛЬНЫЕ ЗНАЧЕНИЯ. Режим фильтра.
													0,				// Задает цвет, используемый при смещениях, выходящих за пределы границ. Допустимый диапазон смещений — от 0,0 до 1,0. Этот параметр используется, если для mode установлено значение DisplacementMapFilterMode.COLOR.
													0.6);			// Задает альфа-значение, используемое при смещениях, выходящих за пределы границ. Указывается в виде нормализованного значения от 0 до 1.
			
			myList.push(displacement);
			mc.filters = myList; // применение фильтра к мувиклипам 'mc'

			// Заполняем массив нулевыми значениями координат Point
			for (var i:uint = 0; i <= numOctaves - 1; i++) {
				offsets.push(new Point());
			}
			
			// Добавляем обработчик события ENTER_FRAME
			this.addEventListener(Event.ENTER_FRAME, enterframe);
		}
		
		
		
		
		
		
		
		/*********************************************
		 *            Обработчик ENTER_FRAME         *
		 *                                           *
		 */ //****************************************
		public function enterframe(event:Event) {
			// заполняем массив координатами смещения искажения каждый раз увеличивая их по x на 2, по y на 0.25 
			// это в зависимости от направления течения воды.
			for (var i:uint = 0; i <= numOctaves - 1; i++) {
				offsets[i].x += 0.2; // 2
				offsets[i].y += 0.25; // 0.25
			}
			
			//Запоминаем текущее состояние фильтров клипа 'mc'
			filterList = mc.filters;
			
			// Применяем шум perlinNoise к BitmapData (45, 5, octava, 50, true, false, 7, true, offsets)
			waterBitmap.perlinNoise(waweX,		// Величина (длина) волны по оси x
									waweY, 		// Величина (высота) волны по оси y
									numOctaves, // Количество октав или индивидуальных функций шума, которые необходимо объединить с целью создания шума. Чем больше октав, тем более детальное изображение создается. Также чем больше октав, тем больше времени требуется на обработку.
									62, 		// Начальное значение, используемое для создания случайных чисел. Если не изменять остальных параметров, можно создавать различные псевдослучайные результаты, изменяя начальное значение случайной последовательности.
									true,		// Сглаживать края перехода изображения?
									false,		// При значении 'true' метод создает фрактальный шум, в противном случае создается турбулентность. Изображение с турбулентностью имеет видимые прерывания градиента, благодаря чему оно больше подходит для более резких визуальных эффектов, например для создания языков пламени или морских волн
									7,			// Число, которое может представлять собой любую комбинацию значений четырех каналов цвета (BitmapDataChannel.RED, BitmapDataChannel.BLUE, BitmapDataChannel.GREEN и BitmapDataChannel.ALPHA). Можно использовать логический оператор ИЛИ (|) для комбинирования значений каналов.
									true,		// При значении 'true' создается изображение с использованием серой шкалы путем присвоения каналам красного, зеленого и синего цветов идентичных значений. Значение альфа-канала остается без изменений, если данному параметру задано значение true.
									offsets); 	// Массив точек, соответствующий смещениям в направлениях x и y для каждой октавы. Изменяя значения смещения, можно плавно прокручивать слои изображения с шумом Перлина.
			
			// применяем данные карты замещения BitmapData к фильтрам DisplacementMapFilter
			filterList.mapBitmap = waterBitmap;
			
			// Возвращаем клипу 'mc' фильтры.
			mc.filters = filterList;	
		}
		
		
		
		
		// разрушение класса
		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, enterframe);
			waterBitmap.dispose();
			waterBitmap = null;
		}
	}
}