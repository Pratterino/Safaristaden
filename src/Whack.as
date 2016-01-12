package  
{		
	//------------------------------------------------------------------------------
	//  Imports
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
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
	
	public class Whack extends State 
	{
		//------------------------------------------------------------------------------
		// Globala definitioner & variablar
		//------------------------------------------------------------------------------
		//MovieClips
		private var krockoHole:MC_Hole = new MC_Hole;
		private var bosseHund:MC_BosseHund = new MC_BosseHund;
		private var currentScore:CurrentScore = new CurrentScore();
		private var hamsternHelmut:HamsternHelmut = new HamsternHelmut;
		private var kim:MC_KimTalk = new MC_KimTalk;
		
		//Variablar, Timers & Strängar
		private var whackLength:int = 7; //Antal hål som spelet ska bestå av. [default = 7].
		private var limitOfKrocko:int = 0; //Bevarar beräkningar om hur många krokodiler som tittar fram.
		private var endGame:int = 0; //Kollar om spelet är igång när man vill avsluta.
		
		//Ljud
		private var PLAYING_FILENAME:String;
		private var mySound:Sound = new Sound();
		private var mySoundChannel:SoundChannel = new SoundChannel();
		private var travelSound:TravelSound = new TravelSound();
		private var whackSound:WhackSound = new WhackSound();
		
		//------------------------------------------------------------------------------
		// Arrayer
		//------------------------------------------------------------------------------
		/**
		 *	@holeArray			Kommer att innehålla alla movieclips för alla hålen. MovieClipsen pushas in i 
		 * 						arrayen och placeras ut i funktionen "initHoles".
		 *  @navigation			Array som innehåller knapparna för hjälp och avsluta/gå tillbaka.
		 */
		
		private var holeArray:Array 		= new Array();
		private var navigation:Array 		= new Array();
		
		
		//--------------------------------------------------------------------------
		//	Constructor method
		//--------------------------------------------------------------------------
		
		/**
		 *	Klassens konstruktor.
		 */
		public function Whack() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
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
			initConversation();
			initNavigation();
		}
		
		/**
		 *	Metoden aktiverar klassens händelselyssnare.
		 * 
		 *	@return void
		 */
		private function initEvents():void
		{
			initHoleArray();
			createCounter();
		}
		
		/**
		 *	Metoden skapar och lägger in instanser av hålen i en array 
		 *  och kallar senare på funktionen som placerar ut hålen på scenen.
		 *
		 *	@return void
		 */
		private function initHoleArray():void
		{
			for (var h:int = 0; h < whackLength; h++)
			{
				var krockoHole = new MC_Hole;
				krockoHole.gotoAndStop(1);
				holeArray.push(krockoHole);
			}			

			initHoles(); //PLACERAR UT HÅLEN PÅ SCENEN.
		}
		
		/**
		 *	Metoden lägger ut hålen som finns i holeArray på scenen.
		 *	Sedan körs spelet igång genom "initConversation".
		 *
		 *	@return void
		 */
		private function initHoles():void
		{
			//FÖRSTA RADEN
			holeArray[0].x	= 240;
			holeArray[0].y	= 150;
			addChild(holeArray[0]);
			
			holeArray[1].x	= 440;
			holeArray[1].y	= 150;
			addChild(holeArray[1]);
			
			//ANDRA RADEN
			holeArray[2].x	= 130;
			holeArray[2].y	= 240;
			addChild(holeArray[2]);
			
			holeArray[3].x	= 340;
			holeArray[3].y	= 240;
			addChild(holeArray[3]);
			
			holeArray[4].x	= 545;
			holeArray[4].y	= 240;
			addChild(holeArray[4]);
			
			//TREDJE RADEN
			holeArray[5].x	= 225;
			holeArray[5].y	= 340;
			addChild(holeArray[5]);
			
			holeArray[6].x	= 440;
			holeArray[6].y	= 340;
			addChild(holeArray[6]);
			
			initConversation(); //STARTAR KONVERSATIONEN.
		}
		
		//KONVERSATION
		/**
		 *	Metoden lägger ut Kim och Helmut på scenen.
		 *	Konversationen startas ochanimationen håller på så länge som ljudklippet är igång.
		 *
		 *	@return void
		 */
		private function initConversation():void 
		{
			kim.x = 630;
			kim.y = 280;
			kim.gotoAndStop(1);
			addChild(kim);
			
			hamsternHelmut.x = 0;
			hamsternHelmut.y = 290;
			addChild(hamsternHelmut);
			
			if (endGame == 0) // Om "endGame" är 1 betyder det att användaren har tryckt på avsluta-knappen.
			{
				startSound("helmutIntro01");
				
				var dynamicTalkTimer:Timer = new Timer(1000,8);
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, initConversation2);
			}
			
			else
			{
				return;
			}
		}
		
		/**
		 *	Denna metod är princip likadan som den ovan.
		 *
		 *	@return void
		 */
		private function initConversation2(event:TimerEvent):void
		{
			hamsternHelmut.gotoAndStop(1);
			if (endGame == 0)
			{
				kim.gotoAndPlay(1);
				startSound("KimIntro");
				
				var dynamicTalkTimer:Timer = new Timer(1000,12);
				dynamicTalkTimer.reset();	
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, initWhackGame);
			}
			
			else
			{
				return;
			}
		}
		
		/**
		 *	Metod för att ett TimerEvent ska kunna stoppa animationer.
		 *
		 *	@return void
		 */
		private function stopConversation(event:TimerEvent):void
		{
			hamsternHelmut.gotoAndStop(1);
			kim.gotoAndStop(1);
		}
		
		/**
		 *	Metod för att kunna stoppa animationer.
		 *
		 *	@return void
		 */
		private function stopConversation2():void
		{
			hamsternHelmut.gotoAndStop(1);
			kim.gotoAndStop(1);
		}
		
		//END KONVERSATION
		
		/**
		 *	Metod som kör igång spelet.
		 *
		 *	@return void
		 */
		private function initWhackGame(event:TimerEvent):void 
		{
			if (endGame == 0)
			{
				initWhackListeners();
				popUpKrocko();
				stopConversation2();
				navigation[1].addEventListener(TouchEvent.TOUCH_BEGIN, beginHelpBtn);
				navigation[1].addEventListener(TouchEvent.TOUCH_OUT, outHelpBtn);
				navigation[1].addEventListener(TouchEvent.TOUCH_END, gotoHelp);
			}
			
			else
			{
				return;
			}
		}
	
		//NAVIGATION BEGIN
		/**
		 *	Metod som lägger in navigationsknapparna i array.
		 *	Knapparna placeras sedan ut på scenen och "Touch" egenskaper läggs till.
		 *
		 *	@return void
		 */
		private function initNavigation():void
		{
			var btn_exit:MC_Exit = new MC_Exit();
			navigation.push(btn_exit);
			
			navigation[0].x = 50;
			navigation[0].y = 50;
			navigation[0].gotoAndStop(1);
			addChild(navigation[0]);
			
			var btn_help:MC_Help = new MC_Help();
			navigation.push(btn_help);
			
			navigation[1].x = stage.stageWidth - (navigation[1].width + 50);
			navigation[1].y = 50;
			navigation[1].gotoAndStop(1);
			addChild(navigation[1]);
			
			navigation[0].addEventListener(TouchEvent.TOUCH_BEGIN, beginExitBtn);
			navigation[0].addEventListener(TouchEvent.TOUCH_OUT, outExitBtn);
			navigation[0].addEventListener(TouchEvent.TOUCH_END, gotoTown);
		}
		
		/**
		 *	Metod för att ge knappen en animation när den trycks ner.
		 *
		 *	@return void
		 */
		private function beginExitBtn(event:TouchEvent):void
		{
			navigation[0].gotoAndStop(2);
		}
		
		private function outExitBtn(event:TouchEvent):void
		{
			navigation[0].gotoAndStop(1);
		}
		
		/**
		 *	Metod för att ge knappen en animation när den trycks ner.
		 *
		 *	@return void
		 */
		private function beginHelpBtn(event:TouchEvent):void
		{
			navigation[1].gotoAndStop(2);
		}
		
		private function outHelpBtn(event:TouchEvent):void
		{
			navigation[1].gotoAndStop(1);
		}	
		
		/**
		 *	Metoden stannar alla ljud som spelas upp och startar ljudet som förklarar spelet.
		 *
		 *	@return void
		 */
		private function gotoHelp(event:TouchEvent):void
		{
			SoundMixer.stopAll();
			
			startSound("KimIntro");
			navigation[1].gotoAndStop(1);
			var talkAnimationDone:Timer = new Timer(1000, 12);
			talkAnimationDone.start();
			talkAnimationDone.addEventListener(TimerEvent.TIMER_COMPLETE, stopConversation);
		}
		
		/**
		 *	Metod som aktiveras när man vill lämna spelet innan det är slut.
		 *	"endGame" sätts till 1 som då avslutar alla funktioner som är påväg att startas.
		 *	När timern är klar körs "clearedGame".
		 *
		 *	@return void
		 */
		private function gotoTown(event:TouchEvent):void
		{
			endGame = 1;
			SoundMixer.stopAll();
			hamsternHelmut.gotoAndStop(1);
			kim.gotoAndPlay(1);
			
			startSound("KimOutro");
			var talkAnimationDone:Timer = new Timer(1000, 4);
			talkAnimationDone.start();
			talkAnimationDone.addEventListener(TimerEvent.TIMER_COMPLETE, clearedGame);
		}
		//NAVIGATION END	
		
		/**
		 *	Metoden aktiverar hålen så att användaren kan trycka på dem.
		 *
		 *	@return void
		 */
		private function initWhackListeners():void
		{
			holeArray[0].addEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap0);
			holeArray[1].addEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap1);
			holeArray[2].addEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap2);
			holeArray[3].addEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap3);
			holeArray[4].addEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap4);
			holeArray[5].addEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap5);
			holeArray[6].addEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap6);
		}
		
		/**
		 *	Metod som tar bort möjligheten att trycka på hålen.
		 *
		 *	@return void
		 */
		private function removeWhackListeners():void
		{
			holeArray[0].removeEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap0);
			holeArray[1].removeEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap1);
			holeArray[2].removeEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap2);
			holeArray[3].removeEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap3);
			holeArray[4].removeEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap4);
			holeArray[5].removeEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap5);
			holeArray[6].removeEventListener(TouchEvent.TOUCH_TAP, krockoHoleTap6);
		}
		
	//HOLE-TAPS
	//Tap 0
		/**
		 *	Metoden aktiveras då användaren trycker på ett hål.
		 *	Testar om hålet har Krocko i sig.
		 *	Animerar en träff och kör metoderna "krockoHitAnimation0" och "addToScore".
		 *
		 *	@return void
		 */
		private function krockoHoleTap0(event:TouchEvent):void
		{
			//TRÄFF
			if (holeArray[0].currentFrame == 2)
			{
				holeArray[0].gotoAndStop(3);
				var hitAnimationTimer:Timer = new Timer(500, 1);
				hitAnimationTimer.start();
				hitAnimationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation0);
				addToScore();
			}
		}
		
		/**
		 *	Metoden sätter hålet till att vara tomt och sedan kör metoden för att slumpmässigt placera ut en ny krocko.
		 *	Nedan följer 6 metoder som är snarlika denna, förutom att de gäller resterande hål.
		 *
		 *	@return void
		 */
		private function krockoHitAnimation0(event:TimerEvent):void
		{
			holeArray[0].gotoAndStop(1);
			popUpKrocko();
			removeEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation0);
		}
		
	//Tap 1
		private function krockoHoleTap1(event:TouchEvent):void
		{
			//TRÄFF
			if (holeArray[1].currentFrame == 2)
			{
				holeArray[1].gotoAndStop(3);
				var hitAnimationTimer:Timer = new Timer(500, 1);
				hitAnimationTimer.start();
				hitAnimationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation1);
				addToScore();
			}
		}
		
		private function krockoHitAnimation1(event:TimerEvent):void
		{
			holeArray[1].gotoAndStop(1);
			popUpKrocko();
			removeEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation1);
		}
		
	//Tap 2
		private function krockoHoleTap2(event:TouchEvent):void
		{
			//TRÄFF
			if (holeArray[2].currentFrame == 2)
			{
				holeArray[2].gotoAndStop(3);
				var hitAnimationTimer:Timer = new Timer(500, 1);
				hitAnimationTimer.start();
				hitAnimationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation2);
				addToScore();
			}
		}
		
		private function krockoHitAnimation2(event:TimerEvent):void
		{
			holeArray[2].gotoAndStop(1);
			popUpKrocko();
			removeEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation2);
		}
		
	//Tap 3
		private function krockoHoleTap3(event:TouchEvent):void
		{
			//TRÄFF
			if (holeArray[3].currentFrame == 2)
			{
				holeArray[3].gotoAndStop(3);
				var hitAnimationTimer:Timer = new Timer(500, 1);
				hitAnimationTimer.start();
				hitAnimationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation3);
				addToScore();
			}
		}
		
		private function krockoHitAnimation3(event:TimerEvent):void
		{
			holeArray[3].gotoAndStop(1);
			popUpKrocko();
			removeEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation3);
		}
		
	//Tap 4
		private function krockoHoleTap4(event:TouchEvent):void
		{
			//TRÄFF
			if (holeArray[4].currentFrame == 2)
			{
				holeArray[4].gotoAndStop(3);
				var hitAnimationTimer:Timer = new Timer(500, 1);
				hitAnimationTimer.start();
				hitAnimationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation4);
				addToScore();
			}
		}
		
		private function krockoHitAnimation4(event:TimerEvent):void
		{
			holeArray[4].gotoAndStop(1);
			popUpKrocko();
			removeEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation4);
		}
		
	//Tap 5
		private function krockoHoleTap5(event:TouchEvent):void
		{
			//TRÄFF
			if (holeArray[5].currentFrame == 2)
			{
				holeArray[5].gotoAndStop(3);
				var hitAnimationTimer:Timer = new Timer(500, 1);
				hitAnimationTimer.start();
				hitAnimationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation5);
				addToScore();
			}
		}
		
		private function krockoHitAnimation5(event:TimerEvent):void
		{
			holeArray[5].gotoAndStop(1);
			popUpKrocko();
			removeEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation5);
		}
		
	//Tap 6
		private function krockoHoleTap6(event:TouchEvent):void
		{
			//TRÄFF
			if (holeArray[6].currentFrame == 2)
			{
				holeArray[6].gotoAndStop(3);
				var hitAnimationTimer:Timer = new Timer(500, 1);
				hitAnimationTimer.start();
				hitAnimationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation6);
				addToScore();
			}
		}
		
		private function krockoHitAnimation6(event:TimerEvent):void
		{
			holeArray[6].gotoAndStop(1);
			popUpKrocko();
			removeEventListener(TimerEvent.TIMER_COMPLETE, krockoHitAnimation6);
		}
		//END HOLE-TAPS
		
		//POP-UP
		/**
		 *	Metoden testar om användarens poäng inte är 10 och att användaren inte tryck på avsluta.
		 *	Ett slumpmässigt tal används för att placera ut krocko i ett av hålen.
		 *	Efter att detta är gjort kallas funktionen "popUpKrocko" som testar om det behövs fler "Krocko's".
		 *
		 *	@return void
		 */
		private function randomPopUp(event:TimerEvent):void
		{
			if (currentScore.currentFrame != 10 && endGame == 0)
			{
				var randomNumber:int = Math.floor(Math.random() * holeArray.length);
			
				holeArray[randomNumber].gotoAndStop(2);
				travelSound.play();
			
				popUpKrocko();
			}
		}
		
		/**
		 *	Metoden testar hur många hål som är upptagna.
		 *	Är gränsen inte nådd körs metoden "randomPopUp" efter att en timer är klar.
		 *
		 *	@return void
		 */
		private function popUpKrocko():void
		{
			var randomTime:int = Math.floor((Math.random() * 3000) + 100);
			for (var d:int = 0; d < holeArray.length; d++)
			{
				limitOfKrocko += holeArray[d].currentFrame;
				//Ifall alla krocko på frame(1) = 7.
				//Ifall alla Krocko på frame(2) = 14.
			}		
			if (limitOfKrocko < 9)
			{
				var dynamicPopUpTimer:Timer = new Timer(randomTime, 1);
				dynamicPopUpTimer.start();
				dynamicPopUpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, randomPopUp);	
				limitOfKrocko = 0;
			}
			else if (limitOfKrocko >= 9)
			{
				limitOfKrocko = 0;
				return;
			}
		}
		
		/**
		 *	Metod som placerar ut poängräknaren.
		 *
		 *	@return void
		 */
		private function createCounter():void 
		{
			currentScore.x = (stage.stageWidth*0.5) - (currentScore.width*0.5);
			currentScore.y = (stage.stageHeight*0.05);
			currentScore.gotoAndStop(11);
			addChild(currentScore);
		}
		
		/**
		 *	Metod som lägger till poäng vid träff.
		 *	Metoden testar också vad den ska göra sedan beroende på hur många poäng användaren har.
		 *	Vid 3 och 7 poäng spelas det upp feedback-ljud.
		 *	Om användaren har 9 när den trycker på en Krocko får användaren 10 poäng totalt och
		 *	spelet avslutas genom att köra "removeWhackListeners" och "gameFinished1".
		 *
		 *	@return void
		 */
		private function addToScore():void
		{
			var frame:int = currentScore.currentFrame;
			if (currentScore.currentFrame == 9)
			{
				frame += 1;
				whackSound.play();
				currentScore.gotoAndStop(frame);
				removeWhackListeners();
				for (var i:int = 0 ; i < holeArray.length; i++ )
				{
					holeArray[i].gotoAndStop(1);
				}
				gameFinished1();
			}
			else if (currentScore.currentFrame == 11)
			{
				currentScore.gotoAndStop(1);
				whackSound.play();
			}
			else
			{
				frame += 1;
				whackSound.play();
				currentScore.gotoAndStop(frame);
			}
			
			if (currentScore.currentFrame == 3 || currentScore.currentFrame == 7)
			{
				var randomNr:int = Math.floor(Math.random() * 3) + 1;
				var callSound:String = "helmutPosFeedback0" + String(randomNr);
				startSound(callSound);
				hamsternHelmut.gotoAndPlay(1);
				
				var talkAnimationDone:Timer = new Timer(1000, 2);
				talkAnimationDone.start();
				talkAnimationDone.addEventListener(TimerEvent.TIMER_COMPLETE, stopConversation);
			}
		}
		
		/**
		 *	Metod som sätter igång fanfaren för när spelet är slut.
		 *	Kallar på metoden "gameFinished2" som påbörjar dialogen.
		 *
		 *	@return void
		 */
		private function gameFinished1():void
		{
			if (endGame == 0)
			{
				startSound("vinst");
				var talkAnimationDone:Timer = new Timer(1000, 5);
				talkAnimationDone.start();
				talkAnimationDone.addEventListener(TimerEvent.TIMER_COMPLETE, gameFinished2);
			}
			
			else
			{
				return;
			}
		}
		
		/**
		 *	Metoden fortsätter konversationen för när spelet avslutas.
		 *	Sedan anropas metoden "gameFinished3".
		 *
		 *	@return void
		 */
		private function gameFinished2(event:TimerEvent):void
		{
			if (endGame == 0)
			{
				startSound("helmutFinished");
				hamsternHelmut.play();
				var talkAnimationDone:Timer = new Timer(1000, 6);
				talkAnimationDone.start();
				talkAnimationDone.addEventListener(TimerEvent.TIMER_COMPLETE, gameFinished3);
			}
			
			else
			{
				return;
			}
		}
		
		/**
		 *	Metoden fortsätter konversationen för när spelet avslutas.
		 *	Sedan anropas metoden "clearedGame".
		 *
		 *	@return void
		 */
		private function gameFinished3(event:TimerEvent):void
		{
			if (endGame == 0)
			{
				hamsternHelmut.gotoAndStop(1);
				kim.gotoAndPlay(1);
				startSound("KimOutro");
				var talkAnimationDone:Timer = new Timer(1000, 4);
				talkAnimationDone.start();
				talkAnimationDone.addEventListener(TimerEvent.TIMER_COMPLETE, clearedGame);
			}
			
			else
			{
				return;
			}
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
			var req:URLRequest = new URLRequest("Ljud/Whack/" + PLAYING_FILENAME + ".mp3");
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
			mySoundChannel = theSound.play();
		}
	//END SOUND
	
	
		/**
		 *	Metod som skickar användaren ut till Startskärmen.
		 *
		 *	@return void
		 */
		private function clearedGame(event:TimerEvent):void
		{
			newState(Menu); //Återgår till huvudmenyn.
		}
	}
}