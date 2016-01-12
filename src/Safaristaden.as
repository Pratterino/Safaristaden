package {	
	//------------------------------------------------------------------------------
	//  Imports
	//------------------------------------------------------------------------------
	
	import flash.display.Sprite;
	
	//------------------------------------------------------------------------------
	//  Public class
	//------------------------------------------------------------------------------
	
	/**
	 *	Applikationens dokumentklass. Denna klass hanterar bytet bellan tillstånd.
	 */
	public class Safaristaden extends Sprite {
		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------
		
		private var currentState:State;
		
		//--------------------------------------------------------------------------
		//	Constructor method
		//--------------------------------------------------------------------------
		
		/**
		 *	Exempelklass för hantering av tillstånd/vyer.
		 */
		public function Safaristaden() {
			init();
		}
		
		//--------------------------------------------------------------------------
		//  Private functions
		//--------------------------------------------------------------------------
		
		/**
		 *	Klassens init-funktion aktiverar klassens nödvändiga komponenter.
		 * 
		 *	@return void
		 */
		private function init():void {
			initState(Intro);
		}
		
		/**
		 *	Denna metod hanterar byten mellan applikationstillstånd. När 
		 *	metoden mottar ett nytt tillstånd städar den upp och slänger 
		 *	det nuvarande tillståndet. Programkoden för varje tillstånd 
		 *	ska finnas i tillståndets egna klass.
		 *
		 *	@param	Det tillstånd som applikationen ska byta till.
		 * 
		 *	@return void
		 */
		public function initState(state:Class):void {
			for(var i:uint = 0; i < numChildren; i++) {
				removeChild(getChildAt(i));
			}
			
			currentState			= new state();
			currentState.newState	= initState; // <- DETTA GÖR DET MÖJLIGT ATT BYTA TILLSTÅND INIFRÅN TILLSTÅND.
			
			addChild(currentState);
		}
	}
}
