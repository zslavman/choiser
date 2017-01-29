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
		
		public var spinning_flag:Boolean = false; // флаг наличия вращения колеса
		
		//public var rotation_flag:Boolean = false; // флаг будет ли колесо вращаться при пуске
		//public var half_flag:Boolean = false; // флаг первое колесо листается, второе - вращается
		
		public var anim_flag:String; // флаг - вид анимации колес
		
		
		

		public function Model(){
		
			// тут будут все данные приложения
			words_arr = ['not_used', 'Потискать', 'Полизать', 'Потрогать', 'Покусать', 'Поцеловать', 'Подержать'];
			verb_arr = ['not_used', 'ухо', 'нос', 'шею', 'руку', 'губы', 'язык'];
			
			animation_kind = ['rotate', 'list', 'half'];
			
			anim_flag = animation_kind[0]; // default
			
			phrazes_arr[0] = ['Запустить'];
			phrazes_arr[1] = ['Остановить'];
			phrazes_arr[2] = ['Сделать'];
			phrazes_arr[3] = ['что-то :)'];
		
		}
	
	}

}