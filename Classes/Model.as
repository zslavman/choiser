package
{
	
	/**
	 * ...
	 * @author zslavman
	 */
	public class Model{
	
		public var phrazes_arr:Array = [];
		public var words_arr:Array = [];
		public var spinning_flag:Boolean = false; // флаг наличия вращения колеса
		public var rotation_flag:Boolean = false; // флаг будет ли колесо вращаться при пуске
		
		

		public function Model(){
		
			// тут будут все данные приложения
			words_arr = ['not used', 'Вася', 'Петя', 'Коля', 'Витёк', 'Вован', 'Дука'];
			phrazes_arr[0] = ['Запустить'];
			phrazes_arr[1] = ['Остановить'];
			phrazes_arr[2] = ['Сделать'];
			phrazes_arr[3] = ['что-то :)'];
		
		}
	
	}

}