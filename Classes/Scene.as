package 
{
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
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	public class Scene extends Sprite {
	
		private var model		:Model;
		public var config_bar	:Config_bar;
		private var mask_config	:Sprite;
		private var myStage		:Stage;
		
		private var roleTween1	:Tween;
		private var roleTween2	:Tween;
		private var open_config	:Tween;
		private var close_config:Tween;
		private var lineStart_y;
		
		private var tween_duration:Number = 0.1;
		
		private var circles:uint = 1; // начало с 1 т.к. в массиве слов первое (нулевое) значение не учитывается
		
		private var clicker					:Sound = new _clicker();
		private var wheel_sound				:Sound = new _wheel_sound();
		private var wheel_sound_double		:Sound = new _wheel_sound_double();
		private var key_click				:Sound = new _key_click();
		private var principles_of_lust		:Sound = new _principles_of_lust();
		private var back_channel			:SoundChannel = new SoundChannel();
		private var s_transform				:SoundTransform;
		private var channel_volume			:Number = 0.25;
		private var default_channel_volume	:Number;
		private var pausePosition			:int;
		
		private var rot_duration:Number = 3000; // мс, устанавливать не менее 2000 
		private var Timer_DurationRot	:Timer = new Timer(250);
		private var Timer_Listing		:Timer = new Timer(80);
		
		private var phraza_temp:String;
		
		private var copy_words_arr:Array = [];
		private var copy_verb_arr:Array = [];
		
		private var phrazes_arr:Array = [];
		
		
		private var point1		: Point;
		private var need_noMOVE	: Boolean = false; // флаг запрета таскания конфига
		private var Start_X		: Number; // х-координата точки хвата конфига
		private var Start_Y		: Number; // y-координата точки хвата конфига
		private var TweenSpeed	: Number = 0.35;
		private var TweenSmClass = Regular.easeOut; //Strong.easeOut
		
		private var mySliderLength:uint = 640;
		private var boundingBox	:Rectangle;
		private var close_config_manualy:Tween;
		
		
		
		
		
		
		
		
		public function Scene(_data:Model, _stage:Stage) { 
			
			model = _data;
			myStage = _stage;
			phrazes_arr = Model.phrazes_arr;
		
			pusk_block.button1.addEventListener(MouseEvent.CLICK, button1_MOUSE_DOWN);
			config_bar_on.addEventListener(MouseEvent.MOUSE_DOWN, config_bar_on_MOUSE_DOWN);
			
			Timer_DurationRot.addEventListener(TimerEvent.TIMER, func_Timer_DurationRot);
			Timer_Listing.addEventListener(TimerEvent.TIMER, func_Timer_Listing);
			
			myStage.addEventListener(Event.ACTIVATE, act);
			myStage.addEventListener(Event.DEACTIVATE, act);
			
			lineStart_y = left_type.y;
			left_type.w1.text = phrazes_arr[2]; // Сделать
			right_type.w1.text = phrazes_arr[3]; // что-то :)
			right_type.w2.text = Verb_arr[2]; // что-то :)
			
			pusk_block.statusbar.text = phrazes_arr[0];
			changeTurn();
			pusk_block.button1.buttonMode = true;
			config_bar_on.buttonMode = true;
			
			s_transform = new SoundTransform (channel_volume);
			default_channel_volume = channel_volume;
			
			if (MUTE) setVolume(0);
		
			back_channel = principles_of_lust.play(0, 1, s_transform);
			back_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
			
			boundingBox = new Rectangle(0, 0, mySliderLength, 0);
			
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
			if (distance >= 20) config_bar.startDrag(false, boundingBox); // начать перетаскивать
		}

		private function config_bar_MOUSE_UP(event: MouseEvent): void {

			myStage.removeEventListener(MouseEvent.MOUSE_MOVE, config_bar_MOUSE_MOVE);
			myStage.removeEventListener(MouseEvent.MOUSE_UP, config_bar_MOUSE_UP);

			config_bar.stopDrag();

			var Position_X: Number = config_bar.x; // точка в которой отпустили мувиклип
			
			if (!need_noMOVE) {
				if (Position_X > 500) { // если менюшку отпустили на позиции Х-координаты больше 500 то возвращаем менюшку вправо
					open_config = new Tween(config_bar, "x", TweenSmClass, config_bar.x, 640, TweenSpeed, true);
					
				} 
				else { // иначе влево
					close_config_manualy = new Tween(config_bar, "x", TweenSmClass, config_bar.x, 0, TweenSpeed, true);
					close_config_manualy.addEventListener(TweenEvent.MOTION_FINISH, Kill_config);
					//TODO: все еще вылетает ошибка с ранним удалением конфигбара
				}
			}
		}
		
		//TODO: прописать переключение флага в слайдер прокрутки скроллбара noMOVE = true;
		
		

		
		
		
		
		
		
		
		
		
		
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
				back_channel = principles_of_lust.play(pausePosition, 1, s_transform);
			}
			
		}
		
		
		
		
		
		
		// зацикливание фоновой музыки
		private function loopSound(event:Event):void{ 
		
			back_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			
			back_channel = principles_of_lust.play(0, 1, s_transform);
			back_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
		}
		
		
		
		
		
		
		/*********************************************
		 *                Кнопка "Config"            *
		 *                 (вызов меню)              *
		 */ //****************************************
		private function config_bar_on_MOUSE_DOWN(event:MouseEvent):void{ 

			key_click.play();
			
			if (config_bar == null) {
				
				config_bar = new Config_bar(model, stage);
				config_bar.addEventListener(MouseEvent.MOUSE_DOWN, config_bar_MOUSE_DOWN);
				addChild(config_bar);
			
				// создание маски для экрана настроек
				mask_config = new Sprite();
				mask_config.graphics.beginFill(0x000000, 1);
				mask_config.graphics.drawRect(0, 0, 640, 1136);
				mask_config.graphics.endFill();
				addChild(mask_config);
				config_bar.mask = mask_config;

				if (config_bar.x == 0) {
					open_config = new Tween (config_bar, 'x', Strong.easeOut, 0, 640, 1, true);
					open_config.addEventListener(TweenEvent.MOTION_FINISH, after_MOTION_FINISH);
				}
				config_bar.mute.addEventListener(MouseEvent.MOUSE_DOWN, mute_MOUSE_DOWN);
				config_bar.mute.buttonMode = true;

			}
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
		 *              Кнопка "MUTE"                *
		 *                                           *
		 */ //****************************************
		private function mute_MOUSE_DOWN(event:MouseEvent):void {
		
			key_click.play();
			
			if (MUTE) {
				MUTE = false;
				config_bar.mute.gotoAndStop('sound_on');
				setVolume(default_channel_volume);
			}
			else {
				MUTE = true;
				config_bar.mute.gotoAndStop('sound_off');
				setVolume(0);
			}
		}
		
		
		private function setVolume(vol:Number):void{ 
		
			channel_volume = vol;
			
			s_transform = back_channel.soundTransform;
			s_transform.volume = channel_volume;
			back_channel.soundTransform = s_transform;
		}
		
		
		
		/*********************************************
		 *                Кнопка "Config"            *
		 *                (убирание меню)            *
		 */ //****************************************
		private function config_bar_off_MOUSE_DOWN(event:MouseEvent):void{ 
			
			key_click.play();
			
			if (config_bar.x == 640) {
				need_noMOVE = true;
				close_config = new Tween (config_bar, 'x', Strong.easeOut, 640, 0, 1, true);
				close_config.addEventListener(TweenEvent.MOTION_FINISH, Kill_config);
				changeTurn('dont_turn');
			}
		}
		
	
		
		
		
		/*********************************************
		 *         Удаление класса Config            *
		 *                                           *
		 */ //****************************************
		public function Kill_config(event:TweenEvent):void {
			
			//changeTurn('dont_turn');
			
			config_bar.config_bar_off.removeEventListener(MouseEvent.MOUSE_DOWN, config_bar_off_MOUSE_DOWN);
			config_bar.mute.removeEventListener(MouseEvent.MOUSE_DOWN, mute_MOUSE_DOWN);
			removeChild(mask_config);
			mask_config = null;
			removeChild(config_bar);
			config_bar = null;
			need_noMOVE = false;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *           Ф-ция меняющая фразы при        *
		 *               смене хода игроков          *
		 */ //****************************************
		private function changeTurn(comand:String = ''):void {
			
			var digit0:uint;
			var digit1:uint;
			
			if (Player_flag) {
				digit0 = 0;
				digit1 = 1;
			}
			else {
				digit0 = 1;
				digit1 = 0;
			}
			var names_padej = []; // массив имен в дательном падеже
			
			// создание массива имен в дательном падеже
			names_padej[0] = changeName(Players_names[0], 'fem'); // женское
			names_padej[1] = changeName(Players_names[1], 'mal'); // мужское
			
			turn.text = phrazes_arr[7] + Players_names[digit1]; // Ходит Игрок1
			who.text = names_padej[digit0] + phrazes_arr[6]; //Игроку2 нужно:
			whom.text = names_padej[digit1]; // Игроку1;
			pusk_block.tip.text = '(' + Players_names[digit0] + ')';

			// выполнять след. строку при любой команде кроме 'dont_turn'
			if (comand != 'dont_turn') Player_flag = !Player_flag; // инверсия флага хода игрока
		}
		
		
		
		
		
		
		/*********************************************
		 *           Ф-ция склоняющая имена          *
		 *                                           *
		 */ //****************************************
		private function changeName(name:String, sex:String):String{ 
		
			// вырезаем последнюю букву
			var last_letter:String = name.substr(name.length - 1, name.length);
			
			// определение заглавная ли буква
			var flag_up_Case:Boolean = false; // флаг заглавной буквы
			if (last_letter === last_letter.toUpperCase()) flag_up_Case = true;
			
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
					new_last_letter = null;
				break;
					
				default:
					new_last_letter = null;
			}
			
			if (flag_up_Case) new_last_letter = new_last_letter.toUpperCase();
			
			if (new_last_letter != null) {
				if (flag_add) name = name + new_last_letter; // просто добавление
				else name = name.slice(0, name.length - 1) + new_last_letter; // удаление с добавлением
			}
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
			
			if (spinning_flag) {
				circles++;
				wheel_sound.play();
				if (circles == copy_words_arr.length) circles = 1;
				left_type.w1.text = copy_words_arr[circles];
				left_type.w2.text = copy_words_arr[circles];
				
				right_type.w1.text = copy_verb_arr[circles];
				right_type.w2.text = copy_verb_arr[circles];
			}
		}
		
		
		
		
		
		
		
		/*********************************************
		 *              Кнопка "Пуск/Стоп"           *
		 *                                           *
		 */ //****************************************
		public function button1_MOUSE_DOWN(event:MouseEvent):void {
			
			if (!spinning_flag && roleTween2 == null) {
				
				key_click.play();
				spinning_flag = true;
				
				//pusk_block.button1.addEventListener(MouseEvent.MOUSE_UP, button1_MOUSE_UP_OUT);
				//pusk_block.button1.addEventListener(MouseEvent.MOUSE_OUT, button1_MOUSE_UP_OUT);

				Games_count++;
				if (Games_count != 1) changeTurn();
				
				// запуск случайной сортировки массива:
				SortMe();
				
				Timer_DurationRot.start();
				if (anim_flag == 'Вращение' || anim_flag == 'Наполовину') startMoove(); // запуск твина вращения слов
				else if (anim_flag == 'Листание') Timer_Listing.start(); // запуск перебора слов (слова будут просто перечисляться по таймеру)
				
				pusk_block.alpha = 0.4;
				pusk_block.button1.buttonMode = false;
				
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
			spinning_flag = false;
			
			tween_duration = 0.1;
			Timer_Listing.reset();
			Timer_Listing.delay = 80;
			
			if (anim_flag == 'Листание') lastStep();
			//stopMoove(); // твин доходит до цикла след. запуска и останавливается
		}
		
		
		/*********************************************
		 *             Твин вращения колеса          *
		 *                                           *
		 */ //****************************************
		public function startMoove():void {
		
			if (anim_flag != 'Наполовину') {
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
			
			if (spinning_flag) {
				circles++;
	
				// запись в первое поле
				left_type.w1.text = copy_words_arr[circles];
				right_type.w1.text = copy_verb_arr[circles];
				
				if (circles == copy_words_arr.length - 1) circles = 0;

				// запись во второе поле
				left_type.w2.text = copy_words_arr[circles + 1];
				right_type.w2.text = copy_verb_arr[circles + 1];
				
				startMoove();
			}
			else { // если остановлено
				// выпавшее слово всегда будет находиться во 2-й текст. ячейке,
				// т.к. остановка происходит лишь после доезда до финиша
				lastStep();
			}
		}
		

		

		
		
		/*********************************************
		 *              Случайная сортировка         *
		 *                   массива                 *
		 */ //****************************************
		private function SortMe():void {
			
			copy_words_arr = Words_arr.slice();
			copy_verb_arr = Verb_arr.slice();
			//copy_verb_arr = model.
			
			
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
			
			Storage.phraza.push(phraza_temp);
			Storage.cur_date.push(current_time['chislo']);
			Storage.cur_time.push(current_time['vremya']);
			
			// обновление отчёта если конфиг открыт
			if (config_bar != null) config_bar.scrollertextFill();

			// т.к. при пуше не используется сеттер, то вызовем его принудительно
			Storage = Storage;
			
			
			//Storage = {
				//phraza:phraza_temp,
				//cur_date: current_time['chislo'],
				//cur_time: current_time['vremya']
			//};
		}
		
		
		
		
		
		// ф-ция получения текущей даты и время
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
		
		
		
		
	
		//TODO: добавить пароль на просмотр архива

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *              GETTERS/SETTERS              *
		 *                                           *
		 */ //****************************************
		public function get Words_arr():* {
			return model.words_arr;
		}
		public function set Words_arr(value:*):void {
			model.words_arr = value;
		}
		
		
		public function get Verb_arr():* {
			return model.verb_arr;
		}
		public function set Verb_arr(value:*):void {
			model.verb_arr = value;
		}
		

		
		public function get spinning_flag():Boolean {
			return model.spinning_flag;
		}
		public function set spinning_flag(value:Boolean):void {
			model.spinning_flag = value;
		}
		
		
		public function get anim_flag():String {
			return model.anim_flag;
		}
		
		public function get Players_names():* {
			return model.players_names;
		}

		
		public function get Player_flag():Boolean {
			return model.player_flag;
		}
		public function set Player_flag(value:Boolean):void {
			model.player_flag = value;
		}
		
		
		public function get Games_count():uint {
			return model.games_count;
		}
		public function set Games_count(value:uint):void {
			model.games_count = value;
		}
		
		
		public function get Storage():Object {
			return model.storage;
		}
		public function set Storage(value:Object):void {
			model.storage = value;
			model.SharedObj.data.storage = model.storage;
			model.SharedObj.flush();
		}
		
		
		public function get MUTE():Boolean {
			return model.mute_flag;
		}
		public function set MUTE(value:Boolean):void {
			model.mute_flag = value;
			model.SharedObj.data.mute_flag = model.mute_flag;
			model.SharedObj.flush();
		}
		
	}
}