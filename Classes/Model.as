package
{
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	import flash.text.*;
	import flash.net.SharedObject;
	 
	 
	 
	 
	public class Model{
	
		public static var myFormat	:TextFormat = new TextFormat();
		public static var phrazes_arr:Array = [];
		
		private var words_arr		:Array = [];
		private var verb_arr		:Array = [];
		private var animation_kind	:Array = [];
		private var players_names	:Array;
		
		private var spinning_flag	:Boolean = false; // флаг наличия вращения колеса
		private var player_flag		:Boolean = true; // флаг какой игрок ходит, true - первый, false - второй
		private var mute_flag		:Boolean; // флаг mute
		
		private var anim_flag		:String; // флаг - вид анимации колес
		
		private var games_count		:uint = 0; // для того что бы не менять ход игроков при первом запуске
		
		private var storage			:Object; // архив-хранилище
		private var need_noMOVE		:Boolean = false; // флаг запрета таскания конфига
		private var first_time		:Boolean; // флаг первого запуска игры
		
		private var SharedObj		:SharedObject;
		
		
		
		
		
		
		

		public function Model() {
		
			// принудительная установка формата, для того, что бы строки не скукоживались, флеш почемуто ставит минусовой кернинг многострочникам
			myFormat.leading = 6;
		
			// тут будут все данные приложения
			words_arr = ['not_used', '?', 'ухо', 'шею', 'грудь', 'губы', 'соски'];
			
			verb_arr = ['not_used', 'Щекотать', 'Лизать', 'Прикосн.', 'Покусать', 'Поцеловать', 'Массажир.'];
			// ласкать, сосать
			
			//animation_kind = ['rotate', 'list', 'half']; // rotate - вращаются оба, list - замена слов в обоих полях, 
			// half - первое поле вращается а второе листается
			animation_kind = ['Вращение', 'Листание', 'Наполовину'];
			
			phrazes_arr[0] = ['След. ход'];
			phrazes_arr[1] = ['. . .'];
			phrazes_arr[2] = ['Сделать'];
			phrazes_arr[3] = ['что-то :)'];
			phrazes_arr[4] = ['Партнер1'];
			phrazes_arr[5] = ['Партнер2'];
			phrazes_arr[6] = [' нужно:'];
			phrazes_arr[7] = ['Ходит '];
			phrazes_arr[8] = ['Сброс'];
			
			phrazes_arr[10] = ["LoversGame v.1.0"];
			phrazes_arr[11] = ['Игра для влюбленных. Просто кликайте по очереди на кнопку и делайте друг другу приятно :)'];
			phrazes_arr[12] = ['Посвящается Ксюшеньке.'];
			phrazes_arr[13] = ['© Вячеслав Зинько, 2017г.\r E-mail: <a href="event:myMail">zslavman@gmail.com</a>'];
			phrazes_arr[14] = ["mailto:zslavman@gmail.com"];
			phrazes_arr[15] = ['16+']; // возраст аудитории игры
			
			phrazes_arr[16] = ['янв'];
			phrazes_arr[17] = ['фев'];
			phrazes_arr[18] = ['мар'];
			phrazes_arr[19] = ['апр'];
			phrazes_arr[20] = ['май'];
			phrazes_arr[21] = ['июн'];
			phrazes_arr[22] = ['июл'];
			phrazes_arr[23] = ['авг'];
			phrazes_arr[24] = ['сен'];
			phrazes_arr[25] = ['окт'];
			phrazes_arr[26] = ['ноя'];
			phrazes_arr[27] = ['дек'];
			phrazes_arr[28] = ['имя существительное'];
			phrazes_arr[29] = ['глагол'];
			
			phrazes_arr[30] = ['При каждом ходе случайным образом выпадает пара слов (желание) которое необходимо исполнить Вашему партнеру.\rВ настройках Вы можете задавать свои желания.'];
			
			phrazes_arr[31] = ['Введите свои имена, ведь Вы не хотите быть просто "Партнер1" и "Партнер2"?'];
			
			
		
			// создаем регулярное выражение для поиска пробелов в названии
			var reg:RegExp = / /g; // парамерт /g маска для всех " " в выражении
			var str1:String = phrazes_arr[10][0].replace(reg, '_');
			
			SharedObj = SharedObject.getLocal(str1, "/"); // параметр "/" - записывает *.SOL не создавая директории
			
			if (SharedObj.data.storage == null) { // если в кукисах нет инфы о хранилище
				storage = {
					phraza:[],
					cur_date:[],
					cur_time:[]
				}
			}
			else storage = SharedObj.data.storage;
			
			if (SharedObj.data.players_names == null) players_names = [phrazes_arr[4], phrazes_arr[5]]; // default
			else players_names = SharedObj.data.players_names;
			
			if (SharedObj.data.anim_flag == null) anim_flag = animation_kind[0]; // default 
			else anim_flag = SharedObj.data.anim_flag;
			
			if (SharedObj.data.mute_flag == null) mute_flag = false; // default 
			else mute_flag = SharedObj.data.mute_flag;
			
			// резервирование массивов слов для восстановления
			if (SharedObj.data.words_arr_reserve == null) {
				
				SharedObj.data.words_arr_reserve = words_arr.slice();
				SharedObj.data.verb_arr_reserve = verb_arr.slice();
			}
			
			// проверяем наличие пользовательских массивов данных
			// если в кукисах есть такой массив, то перезаписываем тот что в программе:
			if (SharedObj.data.words_arr != null) words_arr = SharedObj.data.words_arr.slice();
			if (SharedObj.data.verb_arr != null) verb_arr = SharedObj.data.verb_arr.slice();
			
			if (SharedObj.data.first_time == null) first_time = true; // default
			else first_time = SharedObj.data.first_time;
			
		}
		
		
		
		
		
		/*********************************************
		 *              GETTERS/SETTERS              *
		 *                                           *
		 */ //****************************************
		// через геттер можно менять элементы массива по одному,
		// потому иногда сеттер не используется!!!
		
		public static function get Phrazes_arr():* {
			return phrazes_arr;
		} 
		
		
		
		public function get Animation_kind():* {
			return animation_kind;
		}
		 
		

		 public function get Words_arr():Array {
			SharedObj.data.words_arr = words_arr;
			return words_arr;
		}
		//public function set Words_arr(value:*):void {
			//words_arr = value;
		//}
		
		
		
		public function get Verb_arr():Array {
			SharedObj.data.verb_arr = verb_arr;
			return verb_arr;
		}
		//public function set Verb_arr(value:*):void {
		//}
		

		
		public function get Spinning_flag():Boolean {
			return spinning_flag;
		}
		public function set Spinning_flag(value:Boolean):void {
			spinning_flag = value;
		}
		
		
		
		
		public function get Anim_flag():String {
			return anim_flag;
		}
		public function set Anim_flag(value:String):void {
			anim_flag = value;
			SharedObj.data.anim_flag = anim_flag;
			SharedObj.flush();
		}
		

		
		
		public function get Players_names():* {
			// запись в лок.хранил. из геттера потому что при установке Players_names[x] используется 
			// именно геттер а не сеттер
			SharedObj.data.players_names = players_names;
			SharedObj.flush();
			return players_names;
		}
		public function set Players_names(value:*):void {
			players_names = value;
			SharedObj.data.players_names = players_names;
			SharedObj.flush();
		}

		
		
		
		public function get Player_flag():Boolean {
			return player_flag;
		}
		public function set Player_flag(value:Boolean):void {
			player_flag = value;
		}
		
		
		
		
		public function get Games_count():uint {
			return games_count;
		}
		public function set Games_count(value:uint):void {
			games_count = value;
		}
		
		

		
		
		public function get Storage():Object {
			SharedObj.data.storage = storage;
			SharedObj.flush();
			return storage;
		}
		public function set Storage(value:Object):void {
			storage = value;
			SharedObj.data.storage = storage;
			SharedObj.flush();
		}
		
		
		
		
		
		
		
		public function get MUTE():Boolean {
			return mute_flag;
		}
		public function set MUTE(value:Boolean):void {
			mute_flag = value;
			SharedObj.data.mute_flag = mute_flag;
			SharedObj.flush();
		}
		
		
		
		public function get Words_arr_reserve():Array {
			return SharedObj.data.words_arr_reserve;
		}
		
		
		
		public function get Verb_arr_reserve():Array {
			return SharedObj.data.verb_arr_reserve;
		}
		
		
		
		
		public function get Need_noMOVE():Boolean {
			return need_noMOVE;
		}
		public function set Need_noMOVE(value:Boolean):void {
			need_noMOVE = value;
		}
		
		
		
		
		public function get First_time():Boolean {
			return first_time;
		}
		public function set First_time(value:Boolean):void {
			first_time = value;
			SharedObj.data.first_time = first_time;
		}
	}
}