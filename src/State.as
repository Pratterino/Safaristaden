package  
{	
	//------------------------------------------------------------------------------
	//  Imports
	//------------------------------------------------------------------------------
	import flash.display.Sprite;

	//------------------------------------------------------------------------------
	//  Abstract class
	//------------------------------------------------------------------------------
	
	/**
	 *	Denna klass är en abstrakt klass som alla tillståndsklasser ska ärva ifrån.
	 *	Egenskapen newState ska innehålla metoden initState, detta gör det möjligt 
	 *	att byta tillstånd.
	 */
	public class State extends Sprite
	{
		//--------------------------------------------------------------------------
		//	Public properties
		//--------------------------------------------------------------------------
		
		public var newState:Function;
		
		//Avklarat spel?
		//1 = spelet är icket avklarat.
		//2 = spelet är avklarat.
		public var drumGame:int = 1;
		public var memoryGame:int = 1;
		public var whackGame:int = 1;
		

		
		//--------------------------------------------------------------------------
		//	Constructor method
		//--------------------------------------------------------------------------
		
		/**
		 *	Klassens konstruktor.
		 */
		public function State() 
		{
			//Konstruktor
		}
	}
}