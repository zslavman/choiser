package
{
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	import flash.net.SharedObject;
	 
	 
	 
	 
	public class Model{
	
		public static var phrazes_arr:Array = [];
		public var words_arr:Array = [];
		public var verb_arr:Array = [];
		public var copy_words_arr:Array = [];
		public var copy_verb_arr:Array = [];
		public var animation_kind:Array = [];
		public var players_names:Array;
		
		public var spinning_flag:Boolean = false; // флаг наличия вращения колеса
		public var player_flag:Boolean = true; // флаг какой игрок ходит, true - первый, false - второй
		public var mute_flag:Boolean; // флаг mute
		
		public var anim_flag:String; // флаг - вид анимации колес
		
		public var games_count:uint = 0; // для того что бы не менять ход игроков при первом запуске
		
		public var SharedObj:SharedObject;
		
		public var storage:Object; // архив-хранилище
		
		

		public function Model(){
		
			// тут будут все данные приложения
			words_arr = ['not_used', 'Щекотать', 'Лизать', 'Прикосн.', 'Покусать', 'Поцеловать', 'Массажир.'];
			// ласкать, сосать
			
			verb_arr = ['not_used', 'ухо', '?', 'шею', 'грудь', 'губы', 'соски'];
			
			// копии массивов для их восстановления
			//copy_words_arr = words_arr.slice();
			
			//animation_kind = ['rotate', 'list', 'half']; // rotate - вращаются оба, list - замена слов в обоих полях, 
			// half - первое поле вращается а второе листается
			animation_kind = ['Вращение', 'Листание', 'Наполовину'];
			

			phrazes_arr[0] = ['След. ход'];
			phrazes_arr[1] = ['. . .'];
			phrazes_arr[2] = ['Сделать'];
			phrazes_arr[3] = ['что-то :)'];
			phrazes_arr[4] = ['Игроку1'];
			phrazes_arr[5] = ['Игроку2'];
			phrazes_arr[6] = [' нужно:'];
			phrazes_arr[7] = ['Ходит '];
			phrazes_arr[8] = ['Сброс'];
			
			phrazes_arr[10] = ["LoversGame v.1.0"];
			phrazes_arr[11] = ['Игра для влюбленных. Просто кликайте по очереди на кнопку и делайте друг другу приятно :)'];
			phrazes_arr[12] = ['Посвящается Ксюшеньке.'];
			phrazes_arr[13] = ['© Вячеслав Зинько, 2017г.\r E-mail: <a href="event:myMail">zslavman@gmail.com</a>'];
			phrazes_arr[14] = ["mailto:zslavman@gmail.com"];
			phrazes_arr[15] = [''];
			
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
			phrazes_arr[28] = [''];
		
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
			
			if (SharedObj.data.players_names == null) players_names = ['Оля', 'Коля']; // default
			else players_names = SharedObj.data.players_names;
			
			if (SharedObj.data.anim_flag == null) anim_flag = animation_kind[0]; // default 
			else anim_flag = SharedObj.data.anim_flag;
			
			if (SharedObj.data.mute_flag == null) mute_flag = false; // default 
			else mute_flag = SharedObj.data.mute_flag;
			
			
			
			
			
			
			
		}
	
	}

}