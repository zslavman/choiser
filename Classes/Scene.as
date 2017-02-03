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
	import flash.media.Sound;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	public class Scene extends Sprite {
	
		private var data:Model;
		public var config_bar:Config_bar;
		private var mask_config:Sprite;
		
		private var roleTween1:Tween;
		private var roleTween2:Tween;
		private var open_config:Tween;
		private var close_config:Tween;
		private var lineStart_y;
		
		private var tween_duration:Number = 0.1;
		
		private var circles:uint = 1; // начало с 1 т.к. в массиве слов первое (нулевое) значение не учитывается
		private var clicker:Sound = new _clicker();
		private var wheel_sound:Sound = new _wheel_sound();
		private var wheel_sound_double:Sound = new _wheel_sound_double();
		private var key_click:Sound = new _key_click();
		
		private var rot_duration:Number = 3000; // мс, устанавливать не менее 2000 
		private var Timer_DurationRot:Timer = new Timer(250);
		private var Timer_Listing:Timer = new Timer(80);
		
		private var phraza_temp:String;
		
		
		
		
		
		public function Scene(_model_data:Model) { 
			
			data = _model_data;
		
			pusk_block.button1.addEventListener(MouseEvent.MOUSE_DOWN, button1_MOUSE_DOWN);
			config_bar_on.addEventListener(MouseEvent.MOUSE_DOWN, config_bar_on_MOUSE_DOWN);
			
			Timer_DurationRot.addEventListener(TimerEvent.TIMER, func_Timer_DurationRot);
			Timer_Listing.addEventListener(TimerEvent.TIMER, func_Timer_Listing);
			
			lineStart_y = left_type.y;
			left_type.w1.text = Phrazes_arr[2]; // Сделать
			right_type.w1.text = Phrazes_arr[3]; // что-то :)
			right_type.w2.text = Verb_arr[1]; // что-то :)
			
			pusk_block.statusbar.text = Phrazes_arr[0];
			changeTurn();
			pusk_block.button1.buttonMode = true;
			config_bar_on.buttonMode = true;
		}
		
		
		
		
		
		
		/*********************************************
		 *                Кнопка "Config"            *
		 *                 (вызов меню)              *
		 */ //****************************************
		private function config_bar_on_MOUSE_DOWN(event:MouseEvent):void{ 

			key_click.play();
			
			if (config_bar == null) {
				
				config_bar = new Config_bar(data, stage);
				addChild(config_bar);
				
				// создание маски для экрана настроек
				mask_config = new Sprite();
				mask_config.graphics.beginFill(0x000000, 1);
				mask_config.graphics.drawRect(0, 0, 640, 560);
				mask_config.graphics.endFill();
				addChild(mask_config);
				config_bar.mask = mask_config;

				if (config_bar.x == 0) {
					open_config = new Tween (config_bar, 'x', Strong.easeOut, 0, 640, 1, true);
					open_config.addEventListener(TweenEvent.MOTION_FINISH, after_MOTION_FINISH);
				}
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
		 *                Кнопка "Config"            *
		 *                (убирание меню)            *
		 */ //****************************************
		private function config_bar_off_MOUSE_DOWN(event:MouseEvent):void{ 
			
			key_click.play();
			
			if (config_bar.x == 640) {
				close_config = new Tween (config_bar, 'x', Strong.easeOut, 640, 0, 1, true);
				close_config.addEventListener(TweenEvent.MOTION_FINISH, Kill_config);
				changeTurn('dont_turn');
			}
		}
		
	
		
		
		
		/*********************************************
		 *         Удаления класса Config            *
		 *                                           *
		 */ //****************************************
		public function Kill_config(event:TweenEvent):void {
			
			config_bar.config_bar_off.removeEventListener(MouseEvent.MOUSE_DOWN, config_bar_off_MOUSE_DOWN);
			removeChild(mask_config);
			mask_config = null;
			removeChild(config_bar);
			config_bar = null;
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
			for (var i:int = 0; i < Players_names.length; i++){ 
				names_padej[i] = Players_names[i].slice(0, Players_names[i].length - 1) + 'е';
			}
			
			turn.text = Phrazes_arr[7] + Players_names[digit1]; // Ходит Игрок1
			who.text = names_padej[digit0] + Phrazes_arr[6]; //Игроку2 нужно:
			whom.text = names_padej[digit1]; // Игроку1;
			pusk_block.tip.text = '(' + Players_names[digit0] + ')';

			// выполнять след. строку при любой команде кроме 'dont_turn'
			if (comand != 'dont_turn') Player_flag = !Player_flag; // инверсия флага хода игрока
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
				if (circles == Words_arr.length) circles = 1;
				left_type.w1.text = Words_arr[circles];
				left_type.w2.text = Words_arr[circles];
				
				right_type.w1.text = Verb_arr[circles];
				right_type.w2.text = Verb_arr[circles];
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
				
				pusk_block.alpha = 0.4;
				pusk_block.button1.buttonMode = false;
				
				Games_count++;
				if (Games_count != 1) changeTurn();
				
				// запуск случайной сортировки массива:
				SortMe();
				
				Timer_DurationRot.start();
				if (anim_flag == 'rotate' || anim_flag == 'half') startMoove(); // запуск твина вращения слов
				else if (anim_flag == 'list') Timer_Listing.start(); // запуск перебора слов (слова будут просто перечисляться по таймеру)
			}
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
			
			if (anim_flag == 'list') lastStep();
			//stopMoove(); // твин доходит до цикла след. запуска и останавливается
		}
		
		
		/*********************************************
		 *             Твин вращения колеса          *
		 *                                           *
		 */ //****************************************
		public function startMoove():void {
		
			if (anim_flag != 'half') {
				roleTween1 = new Tween (left_type, 'y', None.easeInOut, lineStart_y, lineStart_y + 47, tween_duration, true);
			}
			roleTween2 = new Tween (right_type, 'y', None.easeInOut, lineStart_y, lineStart_y + 47, tween_duration, true);
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
				left_type.w1.text = Words_arr[circles];
				right_type.w1.text = Verb_arr[circles];
				
				if (circles == Words_arr.length - 1) circles = 0;

				// запись во второе поле
				left_type.w2.text = Words_arr[circles + 1];
				right_type.w2.text = Verb_arr[circles + 1];
				
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
			
			Words_arr.sort(randomSortFunc);
			Verb_arr.sort(randomSortFunc);
			// перемещение элемента 'not used' на 0-е место:
			Words_arr = replaceNotUsed(Words_arr);
			Verb_arr = replaceNotUsed(Verb_arr);
			
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
			temp_str['chislo'] = '[' + temp_arr[3] + ' ' + Phrazes_arr[temp_arr[4] + 15] + ' '; 
			temp_str['vremya'] = temp_arr[0] + ':' + temp_arr[1] + ':' + temp_arr[2] + ']' + ' ';
			
			return temp_str;
		}
		
		
		
		//TODO: добавить сохранение настроек и архива в локальное хранилище
		
		//TODO: добавить кнопку сброса архива
		
		//TODO: добавить пароль на просмотр архива
		
		//TODO: возможность изменения названия действия
		
		//TODO: дизайнерское оформление
		
		//TODO: добавить фоновую музыку
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *              GETTERS/SETTERS              *
		 *                                           *
		 */ //****************************************
		public function get Words_arr():* {
			return data.words_arr;
		}
		public function set Words_arr(value:*):void {
			data.words_arr = value;
		}
		
		
		public function get Verb_arr():* {
			return data.verb_arr;
		}
		public function set Verb_arr(value:*):void {
			data.verb_arr = value;
		}
		
		
		public function get Phrazes_arr():* {
			return data.phrazes_arr;
		}
		public function set Phrazes_arr(value:*):void {
			data.phrazes_arr = value;
		}
		
		
		public function get spinning_flag():Boolean {
			return data.spinning_flag;
		}
		public function set spinning_flag(value:Boolean):void {
			data.spinning_flag = value;
		}
		
		
		public function get anim_flag():String {
			return data.anim_flag;
		}
		
		public function get Players_names():* {
			return data.players_names;
		}

		
		public function get Player_flag():Boolean {
			return data.player_flag;
		}
		public function set Player_flag(value:Boolean):void {
			data.player_flag = value;
		}
		
		
		public function get Games_count():uint {
			return data.games_count;
		}
		public function set Games_count(value:uint):void {
			data.games_count = value;
		}
		
		
		public function get Storage():Object {
			return data.storage;
		}
		public function set Storage(value:Object):void {
			data.storage = value;
			data.SharedObj.data.storage = data.storage;
			data.SharedObj.flush();
		}
		
		
		
		
	}
}