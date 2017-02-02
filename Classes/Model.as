package
{
	
	/**
	 * ...
	 * @author zslavman
	 */
	public class Model{
	
		public var phrazes_arr:Array = [];
		public var words_arr:Array = [];
		public var verb_arr:Array = [];
		public var animation_kind:Array = [];
		public var players_names:Array = [];
		
		public var spinning_flag:Boolean = false; // флаг наличия вращения колеса
		public var player_flag:Boolean = true; // флаг какой игрок ходит, true - первый, false - второй
		public var mute_flag:Boolean = false; // флаг mute
		
		public var anim_flag:String; // флаг - вид анимации колес
		
		public var games_count:uint = 0;
		
		

		public function Model(){
		
			// тут будут все данные приложения
			words_arr = ['not_used', 'Тискать', 'Лизать', 'Ласкать', 'Покусать', 'Поцеловать', 'Массажировать'];
			// кусать, ласкать, щекотать, сосать, прикоснуться
			
			
			verb_arr = ['not_used', 'ухо', '?', 'шею', 'грудь', 'губы', 'язык'];
			// сосок, 
			
			
			players_names = ['Таня', 'Ваня'];
			
			animation_kind = ['rotate', 'list', 'half']; // rotate - вращаются оба, list - замена слов в обоих полях, 
			// half - первое поле вращается а второе листается
			
			anim_flag = animation_kind[0]; // default
			
			phrazes_arr[0] = ['След.ход'];
			phrazes_arr[1] = ['. . .'];
			phrazes_arr[2] = ['Сделать'];
			phrazes_arr[3] = ['что-то :)'];
			phrazes_arr[4] = ['Игроку1'];
			phrazes_arr[5] = ['Игроку2'];
			phrazes_arr[6] = [' нужно:'];
			phrazes_arr[7] = ['Ходит '];
			
			phrazes_arr[10] = ['LoversGame v.1.0'];
			phrazes_arr[11] = ['Игра для влюбленных. Просто кликайте по очереди на кнопку и делайте друг другу приятно :)'];
			phrazes_arr[12] = ['Посвящается Ксюшеньке.'];
			phrazes_arr[13] = ['© Вячеслав Зинько, 2017г.\r E-mail: <a href="event:myMail">zslavman@gmail.com</a>'];
			phrazes_arr[14] = ["mailto:zslavman@gmail.com"];
			phrazes_arr[15] = [''];
		
		}
	
	}

}