package 
{
	import adobe.utils.CustomActions;
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.google.analytics.utils.URL;
	
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	// указывается что бы после этой строки была загрузка лишь после прелоадера 
	[Frame(factoryClass = "Preloader")]
	 
	 
	public class Scene extends MovieClip {
	
		public var splash_screen:Splash_screen;
		public var config_bar	:Config_bar;
		public var mask_main	:Sprite
		//private var mask_config	:Sprite;
		private var fountain	:Fountain;
		private var model		:Model;
		private var myStage		:Stage;
		private var noise1		:Water;
		private var noise2		:Water;
		private var stars		:StarrySky;
		private var clouds		:Clouds;
		private var frameRater	:FrameRater;
		
		public var open_config	:Tween;
		private var roleTween1	:Tween;
		private var roleTween2	:Tween;
		private var close_config:Tween;
		
		private var clouds_wee	:Tween;
		private var stars_wee	:Tween;
		private var pusk_block_wee:Tween;
		private var word1_wee	:Tween;
		private var word2_wee	:Tween;
		private var word3_wee	:Tween;
		private var cfg_wee		:Tween;
		private var palm1_wee	:Tween;
		private var palm2_wee	:Tween;
		private var moon_wee	:Tween;
		
		
		private var lineStart_y;
		private var tween_duration:Number = 0.1;
		
		private var circles:uint = 1; // начало с 1 т.к. в массиве слов первое (нулевое) значение не учитывается
		
		private var clicker					:Sound = new _clicker();
		private var wheel_sound				:Sound = new _wheel_sound();
		private var wheel_sound_double		:Sound = new _wheel_sound_double();
		private var key_click				:Sound = new _key_click();
		private var dawning_sound			:Sound = new _dawning_sound();
		private var fuh						:Sound = new _fuh();
		private var shrub					:Sound = new _shrub();
		private var bung					:Sound = new _bung();
		private var rope_fire				:Sound = new _rope_fire();

		private var back_channel			:SoundChannel = new SoundChannel();
		private var s_transform				:SoundTransform;
		private var pausePosition			:int;
		
		private var rot_duration		:Number = 3000; // мс, устанавливать не менее 2000 
		private var Timer_DurationRot	:Timer = new Timer(250);
		private var Timer_Listing		:Timer = new Timer(80);
		private var Timer_Begin_Animate	:Timer = new Timer(200);
		
		private var phraza_temp:String; // сформировавшаяся фраза из имён и действия
		
		private var copy_words_arr:Array = [];
		private var copy_verb_arr:Array = [];
		
		private var phrazes_arr:Array = [];
		
		
		private var point1		: Point;
		private var Start_X		: Number; // х-координата точки хвата конфига
		private var Start_Y		: Number; // y-координата точки хвата конфига
		private var TweenSpeed	: Number = 0.35;
		private var TweenSmClass = Regular.easeOut; //Strong.easeOut
		
		private var boundingBox	:Rectangle;
		private var close_config_manualy:Tween;
		
		//Аналитика
		private var ACCOUNT_ID	:String = "UA-92344155-1";
		private var BRIDGE_MODE	:String = "AS3";
		private var DEBUG_MODE	:Boolean = false;
		private var love_tracker:GATracker;
		
		
		
		
		
		
		public function Scene(_data:Model, _stage:Stage) { 
			
			model = _data;
			myStage = _stage;
			phrazes_arr = Model.Phrazes_arr;
		
			pusk_block.button1.addEventListener(MouseEvent.CLICK, button1_MOUSE_DOWN);
			config_bar_on.addEventListener(MouseEvent.CLICK, config_bar_on_CLICK);
			
			Timer_DurationRot.addEventListener(TimerEvent.TIMER, func_Timer_DurationRot);
			Timer_Listing.addEventListener(TimerEvent.TIMER, func_Timer_Listing);
			Timer_Begin_Animate.addEventListener(TimerEvent.TIMER, func_Timer_Begin_Animate);
			
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, Key_DOWN);
			
			//myStage.addEventListener(Event.ACTIVATE, act);
			//myStage.addEventListener(Event.DEACTIVATE, act);
			
			lineStart_y = left_type.y;
			
			resetData_on_Circles();
			
			pusk_block.statusbar.text = phrazes_arr[0];
			changeTurn();
			pusk_block.button1.buttonMode = true;
			config_bar_on.buttonMode = true;
			
			
			// фоновая музыка
			s_transform = new SoundTransform (model.Channel_volume);
			
			if (model.MUTE) setVolume(0);
		
			back_channel = dawning_sound.play(0, 1, s_transform);
			back_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
			
			
			boundingBox = new Rectangle(0, 0, 640, 0);
			

			// вода
			noise1 = new Water(BG_movie.obj1, BG_movie.obj1.width, BG_movie.obj1.height, 400, 5); //800, 5
			addChild(noise1);
			noise2 = new Water(BG_movie.obj2, BG_movie.obj2.width, BG_movie.obj2.height, 900, 50, 600, 50);
			addChild(noise2);
			
			// звезды
			stars = new StarrySky(640, 380);
			
			// тучки
			clouds = new Clouds(640, 350, 1, 0, false);
			
			// гугл
			love_tracker = new GATracker(myStage, ACCOUNT_ID, BRIDGE_MODE, DEBUG_MODE);
			
			// фреймрейтер
			frameRater = new FrameRater();
			addChild(frameRater);
			
			
			// маска для прятания за экраном: текстовых полей, конфига и окна "О программе"
			createMainMask();
			
			// начальные состояния для анимации
			pusk_block.alpha = 0;
			turn.x = whom.x = who.x = -640;
			config_bar_on.scaleX = config_bar_on.scaleY = 0;
			BG_movie.palm1.tree_left.x = -400; // 0 - default
			BG_movie.palm2.tree_right.x = 640; // 315 - default
			BG_movie.moon.y = -200; // 157 - default
			
			
			Timer_Begin_Animate.start();
			
			if (model.First_time) {
				Timer_Begin_Animate.reset();
				splash_screen = new Splash_screen(model);
				addChild(splash_screen);
				addEventListener(Event.ENTER_FRAME, checkClosed);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		// ф-ция установки громкости
		public function setVolume(vol:Number):void{ 
		
			model.Channel_volume = vol;
			
			s_transform = back_channel.soundTransform;
			s_transform.volume = model.Channel_volume;
			back_channel.soundTransform = s_transform;
		}
		
		
		

		
		// ф-ция проверяющая закрылось ли окно приветствия
		// вызовется лишь при первом запуске
		private function checkClosed(event: Event) {
			
			if (!model.First_time) {
			
				Timer_Begin_Animate.start();
				changeTurn('dont_turn');
				splash_screen = null;
				removeEventListener(Event.ENTER_FRAME, checkClosed);
			}
		}
		
		
		
		
		
		/*********************************************
		 *             Двигание Configbar'a          *
		 *                                           *
		 */ //****************************************
		private function config_bar_MOUSE_DOWN(event: MouseEvent): void {

			myStage.addEventListener(MouseEvent.MOUSE_MOVE, config_bar_MOUSE_MOVE); // слушатель обработки движения
			myStage.addEventListener(MouseEvent.MOUSE_UP, config_bar_MOUSE_UP);
			Start_X = mouseX; // определение координат точки хвата
			Start_Y = mouseY;
			point1 = new Point(mouseX, mouseY);
		}

		private function config_bar_MOUSE_MOVE(event: MouseEvent): void {

			var point2: Point = new Point(mouseX, mouseY);
			var distance: Number = Point.distance(point1, point2); // вычисл. расст. между двумя точками
			if (distance >= 20 && !model.Need_noMOVE) config_bar.startDrag(false, boundingBox); // начать перетаскивать
		}

		private function config_bar_MOUSE_UP(event: MouseEvent): void {

			myStage.removeEventListener(MouseEvent.MOUSE_MOVE, config_bar_MOUSE_MOVE);
			myStage.removeEventListener(MouseEvent.MOUSE_UP, config_bar_MOUSE_UP);

			config_bar.stopDrag();

			var Position_X: Number = config_bar.x; // точка в которой отпустили мувиклип
			
			if (!model.Need_noMOVE) {
				if (Position_X > 500) { // если менюшку отпустили на позиции Х-координаты больше 500 то возвращаем менюшку вправо
					open_config = new Tween(config_bar, "x", TweenSmClass, config_bar.x, 640, TweenSpeed, true);
					
				} 
				else { // иначе влево
					close_config_manualy = new Tween(config_bar, "x", TweenSmClass, config_bar.x, 0, TweenSpeed, true);
					close_config_manualy.addEventListener(TweenEvent.MOTION_FINISH, Kill_config);
					changeTurn('dont_turn');
					resetData_on_Circles();
				}
			}
		}
	
		

		
		
		
	
		
		
		
		/*********************************************
		 *           Выключении фоновой музыки       *
		 *           при активации/деактивации       *
		 */ //****************************************
		private function act(event:Event):void{ 
		
			if (event.type == 'deactivate') {
				pausePosition = back_channel.position;
				back_channel.stop();
			}
			else if (event.type == 'activate') {
				back_channel.stop();
				back_channel = dawning_sound.play(pausePosition, 1, s_transform);
			}
			
		}
		
		
		
		
		
		
		// зацикливание фоновой музыки
		private function loopSound(event:Event):void{ 
		
			back_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			
			back_channel = dawning_sound.play(0, 1, s_transform);
			back_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
		}
		
		
		
		
		
		
		/*********************************************
		 *                Кнопка "Config"            *
		 *                 (вызов меню)              *
		 */ //****************************************
		private function config_bar_on_CLICK(event:MouseEvent):void{ 

			key_click.play();
			
			if (config_bar == null) {
				
				config_bar = new Config_bar(model, this, stage);
				config_bar.addEventListener(MouseEvent.MOUSE_DOWN, config_bar_MOUSE_DOWN);
				addChild(config_bar);
				if (frameRater != null) addChild(frameRater); // для поднятия в списке отображения

				if (config_bar.x == 0) {
					open_config = new Tween (config_bar, 'x', Strong.easeOut, 0, 640, 1, true);
					open_config.addEventListener(TweenEvent.MOTION_FINISH, after_MOTION_FINISH);
				}
			}
		}
		
		

		
		
		
		
		
		
		/*********************************************
		 *          Создание основной маски          *
		 *                                           *
		 */ //****************************************
		private function createMainMask():void {
			
			mask_main = new Sprite();
			mask_main.graphics.beginFill(0x000000, 1);
			mask_main.graphics.drawRect(0, 0, 640, 1136);
			mask_main.graphics.endFill();
			addChild(mask_main);
			
			this.mask = mask_main;
		}
	
		
		
		
		/*********************************************
		 *         Добавление слушателя после        *
		 *        того как меню выедет до конца      *
		 */ //****************************************
		public function after_MOTION_FINISH(event:TweenEvent):void {
			open_config.removeEventListener(TweenEvent.MOTION_FINISH, after_MOTION_FINISH);
			config_bar.config_bar_off.addEventListener(MouseEvent.MOUSE_DOWN, config_bar_off_MOUSE_DOWN);
			config_bar.config_bar_off.buttonMode = true;
		}
		
		
		
		

		
		
		
		/*********************************************
		 *                Кнопка "Config"            *
		 *                (убирание меню)            *
		 */ //****************************************
		private function config_bar_off_MOUSE_DOWN(event:MouseEvent):void{ 
			
			key_click.play();
			
			if (config_bar.x == 640) {
				model.Need_noMOVE = true;
				close_config = new Tween (config_bar, 'x', Strong.easeOut, 640, 0, 1, true);
				close_config.addEventListener(TweenEvent.MOTION_FINISH, Kill_config);
				changeTurn('dont_turn');
				resetData_on_Circles();
			}
		}
		
	
		
		
		
		/*********************************************
		 *         Удаление класса Config            *
		 *                                           *
		 */ //****************************************
		public function Kill_config(event:TweenEvent):void {
			
			config_bar.config_bar_off.removeEventListener(MouseEvent.MOUSE_DOWN, config_bar_off_MOUSE_DOWN);
			removeChild(config_bar);
			config_bar = null;
			//removeChild(mask_config);
			//mask_config = null;
			model.Need_noMOVE = false;
			//NOTE: принудительная установка фокуса для возможности послед. нажатия Space
			stage.focus = config_bar_on;
			
			packageMaking();
		}
		
		
		
		
		/*********************************************
		 *         Ф-ция формирования посылки        *
		 *                                           *
		 */ //****************************************
		private function packageMaking():void {
			
			// сравнение массивов с эталонными
			var verb:String = '';
			var word:String = '';
			verb = compareUnique(model.Verb_arr, model.Verb_arr_reserve);
			word = compareUnique(model.Words_arr, model.Words_arr_reserve);
			
			if (verb != '' && word != '') {
				//trace ('Verbs: ' + verb + ' ||| ' + 'Words: ' + word);
				love_tracker.trackPageview('Verbs: ' + verb + ' ||| ' + 'Words: ' + word);
			}
			else if (verb != '' && word == '') {
				//trace ('Verbs: ' + verb);
				love_tracker.trackPageview('Verbs: ' + verb);
			}
			else if (verb == '' && word != '') {
				//trace ('Words: ' + word);
				love_tracker.trackPageview('Words: ' + word);
			}
		}
		
		
		
		/*********************************************
		 *         Ф-ция сравнивания элементов       *
		 *            массива с эталонными           *
		 */ //****************************************
		// ф-ция сравнение массивов с эталонными, оставляющая лишь уникальные значения в массиве
		private function compareUnique(my_ar:Array, etalon:Array):String {
			
			var temp_arr:Array = my_ar.slice();
		
			for (var i:Number = 0; i < temp_arr.length; i++){ 
				for (var j:Number = 0; j < etalon.length; j++) {
					
					// если эл.массива равен эл.эталонного массива - удаляем его
					if (temp_arr[i] == etalon[j]) {
						temp_arr.splice(i, 1);
						j = -1;
					}
				}
			}
			
			// сшиваем массив, если он не пустой
			var str1:String = '';
			if (temp_arr.length) str1 = temp_arr.join(', ');

			return str1;
		}
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *           Ф-ция меняющая фразы при        *
		 *               смене хода игроков          *
		 */ //****************************************
		public function changeTurn(comand:String = ''):void {
			
			var digit0:uint;
			var digit1:uint;
			
			if (model.Player_flag) {
				digit0 = 0;
				digit1 = 1;
			}
			else {
				digit0 = 1;
				digit1 = 0;
			}
			var names_padej = []; // массив имен в дательном падеже
			
			// создание массива имен в дательном падеже
			names_padej[0] = changeName(model.Players_names[0], 'fem'); // женское
			names_padej[1] = changeName(model.Players_names[1], 'mal'); // мужское
			
			turn.text = phrazes_arr[7] + model.Players_names[digit1]; // Ходит Игрок1
			who.text = names_padej[digit0] + phrazes_arr[6]; //Игроку2 нужно:
			whom.text = names_padej[digit1]; // Игроку1;
			pusk_block.tip.text = '(' + model.Players_names[digit0] + ')';

			// выполнять след. строку при любой команде кроме 'dont_turn'
			if (comand != 'dont_turn') model.Player_flag = !model.Player_flag; // инверсия флага хода игрока
		}
		
		
		
		
		
		
		/*********************************************
		 *           Ф-ция склоняющая имена          *
		 *                                           *
		 */ //****************************************
		private function changeName(name:String, sex:String):String{ 
		
			// вырезаем последнюю букву
			var last_letter:String = name.substr(name.length - 1, name.length);
			
			// определение заглавная ли буква в конце
			var flag_up_Case:Boolean = false; // флаг заглавной буквы
			//var reg:RegExp = /[а-яА-Яa-zA-Z]/g; // все буквы
			if (last_letter === last_letter.toUpperCase() /*&& reg.test(last_letter)*/) flag_up_Case = true;
			
			last_letter = last_letter.toLowerCase();
			
			var new_last_letter:String;
			var flag_add:Boolean = false; // флаг, что нужно добавлять к имени (без удаления посл. буквы)
			
			switch (last_letter){
				
				case 'а':
				case 'я':
					new_last_letter = 'е';
				break;
				
				case 'б':
				case 'в':
				case 'г':
				case 'д':
				case 'ё':
				case 'ж':
				case 'з':
				case 'к':
				case 'л':
				case 'м':
				case 'н':
				case 'п':
				case 'р':
				case 'с':
				case 'т':
				case 'ф':
				case 'х':
				case 'ц':
				case 'ч':
				case 'ш':
				case 'щ':
					if (sex == 'mal') new_last_letter = 'у';
					else if (sex == 'fem') new_last_letter = 'е';
					flag_add = true;
				break;

				case 'й':
				case 'ь':
					new_last_letter = 'ю';
				break;
				
				case 'е':
				case 'и':
				case 'о':
				case 'у':
				case 'ъ':
				case 'э':
				case 'ю':
					new_last_letter = last_letter;
				break;
					
				default:
					new_last_letter = last_letter;
			}
			
			if (flag_up_Case) new_last_letter = new_last_letter.toUpperCase();
			
			if (flag_add) name = name + new_last_letter; // просто добавление
			else name = name.slice(0, name.length - 1) + new_last_letter; // удаление с добавлением

			return name;
		}
		
		
		
		
		
		
	
		
		/*********************************************
		 *              Таймер длительности          *
		 *                 анимации слов             *
		 */ //****************************************
		private function func_Timer_DurationRot(event:TimerEvent):void{ 
			
			if (Timer_DurationRot.currentCount >= 8) {
				tween_duration += 0.2;
			}
			if (Timer_DurationRot.currentCount > 9) {
				Timer_Listing.delay += 25;	
			}
			
			if (Timer_DurationRot.currentCount == rot_duration/Timer_DurationRot.delay) { // 12
				stopMoove();
			}
			
		}
		
		/*********************************************
		 *              Таймер листания слов         *
		 *                                           *
		 */ //****************************************
		private function func_Timer_Listing(event:TimerEvent):void { 
			
			if (model.Spinning_flag) {
				circles++;
				wheel_sound.play();
				if (circles == copy_words_arr.length) circles = 1;
				left_type.w1.text = copy_verb_arr[circles];
				left_type.w2.text = copy_verb_arr[circles];
				
				right_type.w1.text = copy_words_arr[circles];
				right_type.w2.text = copy_words_arr[circles];
			}
		}
		
		
		
		
		
		
		/*********************************************
		 *               Таймер анимации             *
		 *               появления сцены             *
		 */ //****************************************
		private function func_Timer_Begin_Animate(event:TimerEvent):void { 
			
			switch (Timer_Begin_Animate.currentCount) {
				
				case 1:
					fuh.play();
					word1_wee = new Tween(turn, "x", Back.easeOut, -640, 33, 0.5, true);
					break;
					
				case 2:
					fuh.play();
					word3_wee = new Tween(who, "x", Back.easeOut, -640, 33, 0.5, true);
					break;
					
				case 3:
					fuh.play();
					word2_wee = new Tween(whom, "x", Back.easeOut, -640, 33, 0.5, true);
					break;
				
				case 4:
					rope_fire.play();
					pusk_block_wee = new Tween(pusk_block, "alpha", None.easeOut, 0, 1, 0.3, true);
					break;
				
				case 6:
					shrub.play();
					palm1_wee = new Tween(BG_movie.palm1.tree_left, "x", Back.easeOut, -300, 0, 1, true);
					palm1_wee  = new Tween(BG_movie.palm1.tree_left, "rotation", Back.easeOut, -20, 0, 1, true);

					break;
					
				case 7:
					shrub.play();
					palm2_wee = new Tween(BG_movie.palm2.tree_right, "x", Back.easeOut, 640, 315, 1, true);
					palm2_wee  = new Tween(BG_movie.palm2.tree_right, "rotation", Back.easeOut, 20, 0, 1, true);
					break;
					
				case 8:
					BG_movie.addChildAt(stars, 5);
					stars_wee = new Tween(stars, "y", Strong.easeOut, -380, 0, 1, true);
					break;
					
				case 10:
					moon_wee = new Tween(BG_movie.moon, "y", Strong.easeOut, -200, 157, 3, true);
					
					BG_movie.addChildAt(clouds, 6);
					clouds_wee = new Tween(clouds, "x", Back.easeOut, -640, 0, 1, true);
					
					break;
					
				case 13:
					bung.play();
					cfg_wee = new Tween(config_bar_on, "scaleX", Back.easeOut, 0, 1, 0.7, true);
					cfg_wee = new Tween(config_bar_on, "scaleY", Back.easeOut, 0, 1, 0.7, true);

					Timer_Begin_Animate.reset();
					break;
					
			}
			
		}
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *              Кнопка "Пуск/Стоп"           *
		 *                                           *
		 */ //****************************************
		public function button1_MOUSE_DOWN(event:MouseEvent):void {
			
			if (!model.Spinning_flag && roleTween2 == null) {
				
				key_click.play();
				model.Spinning_flag = true;
				
				//pusk_block.button1.addEventListener(MouseEvent.MOUSE_UP, button1_MOUSE_UP_OUT);
				//pusk_block.button1.addEventListener(MouseEvent.MOUSE_OUT, button1_MOUSE_UP_OUT);

				model.Games_count++;
				if (model.Games_count != 1) changeTurn();
				
				// запуск случайной сортировки массива:
				SortMe();
				
				Timer_DurationRot.start();
				if (model.Anim_flag == 'Вращение' || model.Anim_flag == 'Наполовину') startMoove(); // запуск твина вращения слов
				else if (model.Anim_flag == 'Листание') Timer_Listing.start(); // запуск перебора слов (слова будут просто перечисляться по таймеру)
				
				pusk_block.alpha = 0.4;
				pusk_block.button1.buttonMode = false;
				
			}
			if (fountain != null) {
				fountain.destroy();
				removeChild(fountain);
				fountain = null;
			}
		}
		
		
		
		// при отпускании кнопки Пуск
		private function button1_MOUSE_UP_OUT(event:MouseEvent):void{ 
		
			pusk_block.button1.removeEventListener(MouseEvent.MOUSE_UP, button1_MOUSE_UP_OUT);
			pusk_block.alpha = 0.4;
			pusk_block.button1.buttonMode = false;
		}
		
		
		
		
		
		/*********************************************
		 *          Остановка вращения колеса        *
		 *                                           *
		 */ //****************************************
		public function stopMoove():void{ 
		
			Timer_DurationRot.reset();
			model.Spinning_flag = false;
			
			tween_duration = 0.1;
			Timer_Listing.reset();
			Timer_Listing.delay = 80;
			
			if (model.Anim_flag == 'Листание') lastStep();
			//stopMoove(); // твин доходит до цикла след. запуска и останавливается
		}
		
		
		/*********************************************
		 *             Твин вращения колеса          *
		 *                                           *
		 */ //****************************************
		public function startMoove():void {
		
			if (model.Anim_flag != 'Наполовину') {
				roleTween1 = new Tween (left_type, 'y', None.easeInOut, lineStart_y, lineStart_y + 75, tween_duration, true); //136
			}
			roleTween2 = new Tween (right_type, 'y', None.easeInOut, lineStart_y, lineStart_y + 75, tween_duration, true);
			roleTween2.addEventListener(TweenEvent.MOTION_FINISH, Loop);
		}
		
		
		/*********************************************
		 *       Зацикливание вращения колеса        *
		 *                                           *
		 */ //****************************************
		public function Loop(event:TweenEvent):void {
			
			roleTween2.removeEventListener(TweenEvent.MOTION_FINISH, Loop);

			wheel_sound.play();
			
			if (model.Spinning_flag) {
				circles++;
	
				// запись в первое поле
				left_type.w1.text = copy_verb_arr[circles];
				right_type.w1.text = copy_words_arr[circles];
				
				if (circles == copy_words_arr.length - 1) circles = 0;

				// запись во второе поле
				left_type.w2.text = copy_verb_arr [circles + 1];
				right_type.w2.text = copy_words_arr[circles + 1];
				
				startMoove();
			}
			else { // если остановлено
				// выпавшее слово всегда будет находиться во 2-й текст. ячейке,
				// т.к. остановка происходит лишь после доезда до финиша
				lastStep();
			}
		}
		

		// сброс данных колеса при выходе из кофигбар
		public function resetData_on_Circles():void {
		
			left_type.w1.text = phrazes_arr[2]; // Сделать
			left_type.w2.text = phrazes_arr[2]; // Сделать
			right_type.w1.text = phrazes_arr[3]; // что-то :)
			right_type.w2.text = phrazes_arr[3]; // что-то :)
		}
		

		
		
		/*********************************************
		 *              Случайная сортировка         *
		 *                   массива                 *
		 */ //****************************************
		private function SortMe():void {
			
			//copy_words_arr = Words_arr.slice();
			copy_words_arr = model.Words_arr.slice();
			copy_verb_arr = model.Verb_arr.slice();

			copy_words_arr.sort(randomSortFunc);
			copy_verb_arr.sort(randomSortFunc);
			// перемещение элемента 'not used' на 0-е место:
			copy_words_arr = replaceNotUsed(copy_words_arr);
			copy_verb_arr = replaceNotUsed(copy_verb_arr);
			
		}
		 
		 private function randomSortFunc(a, b):Number {
			return Math.random() - 0.5;
		}
		
		
		
		
		private function replaceNotUsed(array:Array):Array{ 

			for (var i:int = 0; i < array.length; i++){ 
				if (array[i] == 'not_used') {
					
					// перемещение метод 1:
					//array.splice(i, 1); // удаляем найденный элемент массива
					//array.unshift('not used'); // добавляем элемент в начало массива
					
					// перемещение метод 2:
					var temp:String = array[0];
					array[i] = temp;
					array[0] = 'not_used';
				}
			}
			return array;
		}
		
		
		
		
		
		
		
		// последний рывок до остановки колес
		private function lastStep():void {

			turn.text = '';
			pusk_block.alpha = 1;
			pusk_block.button1.buttonMode = true;
			roleTween2 = null;
			
			// формирование фразы для архива
			phraza_temp = who.text + ' ' + left_type.w2.text + ' ' + right_type.w2.text + ' ' + whom.text;
			
			storeResult();
		}
		
		
		
		// ф-ция добавления результатов в архив
		private function storeResult():void { 
			
			var current_time:Array = getTimeNow();
			
			model.Storage.phraza.push(phraza_temp);
			model.Storage.cur_date.push(current_time['chislo']);
			model.Storage.cur_time.push(current_time['vremya']);
			
			// обновление отчёта если конфиг открыт
			if (config_bar != null) config_bar.scrollertextFill();

			// т.к. при пуше не используется сеттер, то вызовем его принудительно
			model.Storage = model.Storage;
			
			//Storage = {
				//phraza:phraza_temp,
				//cur_date: current_time['chislo'],
				//cur_time: current_time['vremya']
			//};
		}
		
		
		
		
		
		// ф-ция получения текущей даты и времени
		private function getTimeNow():Array {
		
			var currentDate:Date = new Date();
			
			var hours:uint = currentDate.getHours();
			var minutes:uint = currentDate.getMinutes();
			var seconds:uint = currentDate.getSeconds();
			
			var date:uint = currentDate.getDate();
			var month:uint = currentDate.getMonth() + 1;
			//var year:uint = currentDate.getFullYear();
			
			var temp_arr:Array = [hours, minutes, seconds, date, month];
			
			for (var i:int = 0; i < temp_arr.length - 2; i++){ 
				if (temp_arr[i] < 10) temp_arr[i] = '0' + temp_arr[i];
			}
			
			var temp_str:Array = [];
			// 15 - с 16-го числа начинается месяца в массиве фраз
			temp_str['chislo'] = '[' + temp_arr[3] + ' ' + phrazes_arr[temp_arr[4] + 15] + ' '; 
			temp_str['vremya'] = temp_arr[0] + ':' + temp_arr[1] + ':' + temp_arr[2] + ']' + ' ';
			
			return temp_str;
		}
		
		
		
		
		
		
		
		
		/*********************************************
		 *          Кнопка клавиатуры "Space"        *
		 *                                           *
		 */ //****************************************
		 
		// charCode - код символа; keyCode - код клавиши
		//trace(String.fromCharCode(event.charCode));

		public	function Key_DOWN(event: KeyboardEvent) {
		
			
			if (config_bar != null) { // если открыт конфигбар
				if (event.keyCode == 27 || event.keyCode == 32) { // клавиша "Esc"/"Space"
					if (config_bar.about_scr != null) { // если открыто окно "О программе"
						config_bar.about_scr.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
					if (!open_config.isPlaying) {
						config_bar.config_bar_off.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
						config_bar.config_bar_off.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP)); // для устранения перетаскивания конфигбара
					}
				}
			} // если закрыт конфигбар
			else if (config_bar == null && splash_screen == null) {
				if (event.keyCode == 32) { // нажатие "Space"
					config_bar_on.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
			
		}
		
		
		
		
		

		
	
		//TODO: добавить пароль на просмотр архива

		
	
	}
}