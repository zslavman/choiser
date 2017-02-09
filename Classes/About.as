package 
{
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.*;

	
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	public class About extends Sprite{
		

		private var mailCSS:StyleSheet = new StyleSheet();
		private var phrazes_arr:Array = [];
		
		
		
		
		
		public function About(){ 
			
			//this.filters = null;
			phrazes_arr = Model.phrazes_arr;
			this.buttonMode = true;
			this.container.mouseChildren = false;

			// линка с почтой:
			mailCSS.setStyle("a:link", {color:'#CC9966', textDecoration:'none'}); // 0000CC
			mailCSS.setStyle("a:hover", { color:'#BB0A0A', textDecoration:'underline' } ); // 0000FF
			
			author.styleSheet = mailCSS;
			author.addEventListener(TextEvent.LINK, linkHandler); // слушатель линка в тексте
			
			textFill();
		}
		
		
		
		
		
		/*********************************************
		 *         Заполнение текстовых полей        *
		 *                                           *
		 */ //****************************************
		public function textFill():void {
			
			container.ver.text = phrazes_arr[10];
			container.about_pro.text = phrazes_arr[11]; 
			container.ksiu.text = phrazes_arr[12];
			author.text = phrazes_arr[13];
		}
		
		
		
		
		
		
		/*********************************************
		 *                 Л и н к и                 *
		 *                                           *
		 */ //****************************************
		public function linkHandler(linkEvent:TextEvent):void {
			
			if (linkEvent.text == "myMail") {
				var myRequest:URLRequest = new URLRequest(phrazes_arr[14]);
				navigateToURL(myRequest);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *              GETTERS/SETTERS              *
		 *                                           *
		 */ //****************************************

		
	}

}