package
{
	//------------------------------------------------------------------------------
	//  Import
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	//import flash.desktop.NativeApplication;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	
	//Lyssna och registrera vilken enskild punkt användaren trycker, ej gester eller multi.
	Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	
	//------------------------------------------------------------------------------
	//  Public class
	//------------------------------------------------------------------------------	
	/**
	 *	Ett enkelt tillstånd för applikationen, den ärver sina grundläggande 
	 *	funktionalliteter från State.
	 */	
	public class Intro extends State
	{
		//------------------------------------------------------------------------------
		// Globala definitioner & variablar
		//------------------------------------------------------------------------------
		//Karaktärer
		private var Kim:MC_KimTalk = new MC_KimTalk;
		
		//------------------------------------------------------------------------------
		// Ljudfiler
		//------------------------------------------------------------------------------
		private var PLAYING_FILENAME:String;
		private var mySound:Sound = new Sound();
		private var mySoundChannel:SoundChannel = new SoundChannel();
		
		//Arrayer
		private var woodArray:Array = new Array();
		
		//MovieClips
		private var woodIndicator:MC_WoodIndicator = new MC_WoodIndicator;
		
		//Timers
		private var dynamicTalkTimer1:Timer = new Timer(1000,19);
		private var dynamicTalkTimer2:Timer = new Timer(1000,4);
		
		/**
		 *	Klassens konstruktor.
		 */
		public function Intro() 			
		{
			SoundMixer.stopAll();
			addEventListener(Event.ADDED_TO_STAGE, init);
			//NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,preventPhoneBtn);
		}
		
		//--------------------------------------------------------------------------
		//	Private methods
		//--------------------------------------------------------------------------
		
		/**
		 *	Klassens init-funktion aktiverar klassens nödvändiga komponenter.
		 * 
		 *	@return void
		 */
		private function init(event:Event = null):void 
		{
			initEvents();
			initKim();
		}
	
		/**
		 *	@preventPhoneBtn	Förhindrar att bakåt, sök eller menyknappen stänger applikationen.
		 * 
		 */
		/*private function preventPhoneBtn(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.MENU :
					break;
				
				case Keyboard.BACK :
					event.preventDefault();
					break;
				
				case Keyboard.SEARCH :
					event.preventDefault();
					break;
			}
		}
		*/

		
		/**
		 *	Metoden aktiverar klassens händelselyssnare.
		 * 
		 *	@return void
		 */
		
		private function initEvents():void 
		{
			addButtons();
		}
		
		/**
		 *	Metod som skapar och placerar ut Räven Kim på scenen.
		 * 
		 *	@return void
		 */
		private function initKim():void 
		{
			var Kim = new MC_KimTalk();
			Kim.x 	= 400;
			Kim.y 	= 220;
			addChild(Kim);
			
			initConversation();
		}
	
	//KONVERSATION START
		private function initConversation():void
		{
			startSound("KimIntro");

			dynamicTalkTimer1.start();
			dynamicTalkTimer1.addEventListener(TimerEvent.TIMER_COMPLETE, initConversation2);
		}
	
		private function initConversation2(event:TimerEvent):void
		{
			startSound("KimKnappInfo");
			
			dynamicTalkTimer2.start();
			dynamicTalkTimer2.addEventListener(TimerEvent.TIMER_COMPLETE, endConversation);
		}
		
		private function endConversation(event:TimerEvent):void
		{
			Kim.gotoAndStop(1);
			newState(Menu);			
		}
	//KONVERSATION END
		
		/**
		 *	Metoden skapar en ny markör.
		 *
		 *	@param	Tillståndet som aktiverade metoden.
		 * 
		 *	@return void
		 */
		private function addButtons():void 
		{
			var Hus1 	= new MC_Button();
			Hus1.x 		= 61;
			Hus1.y 		= 279;
			Hus1.width 	= 164;
			Hus1.height = 164;
			Hus1.alpha 	= 0;
			addChild(Hus1);
			
			var Hus2 = new MC_Button();
			Hus2.x 		= 190;
			Hus2.y 		= 110;
			Hus2.width 	= 300;
			Hus2.height = 165;
			Hus2.alpha 	= 0;
			addChild(Hus2);
			
			var Hus3 	= new MC_Button();
			Hus3.x 		= 564;
			Hus3.y 		= 115;
			Hus3.width 	= 240;
			Hus3.height	= 226;
			Hus3.alpha 	= 0;
			addChild(Hus3);
			
			/*
			*
			* Lägger till lyssnare för tryck på något av de olika husen
			*
			*/
			Hus1.addEventListener(TouchEvent.TOUCH_TAP, whackState);
			Hus2.addEventListener(TouchEvent.TOUCH_TAP, drumState);
			Hus3.addEventListener(TouchEvent.TOUCH_TAP, memoryState);
			
			initWoodIndicators();
		}
		
		private function initWoodIndicators():void
		{
			var woodIndicator0 = new MC_WoodIndicator;
			woodArray.push(woodIndicator0);
			
			woodArray[0].x 		= 340;
			woodArray[0].y 		= 295;
			woodArray[0].scaleX	= -1.3;
			woodArray[0].scaleY	= 1.3;
			woodArray[0].gotoAndStop(whackGame);
			addChild(woodArray[0]);
			
			var woodIndicator1 = new MC_WoodIndicator;
			woodArray.push(woodIndicator1);
			
			woodArray[1].x 		= 180;
			woodArray[1].y 		= 180;
			woodArray[1].scaleX	= 0.7;
			woodArray[1].scaleY	= 0.7;
			
			woodArray[1].gotoAndStop(drumGame);
			addChild(woodArray[1]);
			
			var woodIndicator2 = new MC_WoodIndicator;
			woodArray.push(woodIndicator2);
			
			woodArray[2].x 		= 480;
			woodArray[2].y 		= 180;
			woodArray[2].scaleX	= 1;
			woodArray[2].scaleY	= 1;
			woodArray[2].gotoAndStop(memoryGame);
			addChild(woodArray[2]);
			
			woodArray[0].addEventListener(TouchEvent.TOUCH_TAP, whackState);
			woodArray[1].addEventListener(TouchEvent.TOUCH_TAP, drumState);
			woodArray[2].addEventListener(TouchEvent.TOUCH_TAP, memoryState);
		}
		
	//START SOUND
		/**
		 * @startSound		Laddar in en extern mp3-fil enligt sökvägen "sounds/ + filename + .mp3".
		 * 
		 */
		private function startSound(SOUND_NAME):void
		{
			var PLAYING_FILENAME = SOUND_NAME;
			trace("PLAYING_FILENAME startSound: " + PLAYING_FILENAME);
			
			mySoundChannel.stop();
			var snd:Sound = new Sound();
			var req:URLRequest = new URLRequest("Ljud/Menu/" + PLAYING_FILENAME + ".mp3");
			snd.addEventListener(Event.COMPLETE, soundLoaded);	
			
			snd.load(req);
		}
		
		/**
		 *	Spelar upp ljudet efter det har laddats in och lokaliserats på "disken".
		 *  Påbörjar sedan uppspelningen i SoundChanneln: "mySoundChannel"
		 *
		 */
		private function soundLoaded(event:Event):void 
		{
			var theSound:Sound = event.target as Sound;
			SoundMixer.stopAll();
			mySoundChannel = theSound.play();
		}
	//END SOUND
		
		/**
		 *	Metoden gör så att applikationen går till de olika speltillstånden.
		 *
		 *	@param	Tillståndet som aktiverade metoden.
		 * 
		 *	@return void
		 */
		private function memoryState(event:TouchEvent):void
		{
			dynamicTalkTimer1.stop();
			dynamicTalkTimer2.stop();
			dynamicTalkTimer1.removeEventListener(TimerEvent.TIMER_COMPLETE, initConversation2);
			dynamicTalkTimer2.removeEventListener(TimerEvent.TIMER_COMPLETE, endConversation);
			
			SoundMixer.stopAll();
			newState(Memory);
		}
		
		private function drumState(event:TouchEvent):void 
		{
			dynamicTalkTimer1.stop();
			dynamicTalkTimer2.stop();
			dynamicTalkTimer1.removeEventListener(TimerEvent.TIMER_COMPLETE, initConversation2);
			dynamicTalkTimer2.removeEventListener(TimerEvent.TIMER_COMPLETE, endConversation);
			
			SoundMixer.stopAll();
			newState(Drums);
		}
		
		private function whackState(event:TouchEvent):void 
		{
			dynamicTalkTimer1.stop();
			dynamicTalkTimer2.stop();
			dynamicTalkTimer1.removeEventListener(TimerEvent.TIMER_COMPLETE, initConversation2);
			dynamicTalkTimer2.removeEventListener(TimerEvent.TIMER_COMPLETE, endConversation);
			
			SoundMixer.stopAll();
			newState(Whack);
		}
	}
}