package  
{		
	//------------------------------------------------------------------------------
	//  Imports
	//------------------------------------------------------------------------------
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.TouchEvent;
	import flash.events.TimerEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	//Lyssna och registrera vilken enskild punkt användaren trycker, ej gester eller multi.
	Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	
	/**
	 *	Ett enkelt tillstånd för applikationen, den ärver sina grundläggande 
	 *	funktionalliteter från State.
	 */
	
	public class Memory extends State 
	{
		//------------------------------------------------------------------------------
		// Globala definitioner & variablar
		//------------------------------------------------------------------------------
		//Karaktärer
		private var Kim:MC_KimTalk = new MC_KimTalk;
		private var Nabblund:MC_Nabblund = new MC_Nabblund;
			
		//Memorybrickor
		private var memoryCard:MC_memoryCard = new MC_memoryCard;
		
		//------------------------------------------------------------------------------
		// Ljudfiler
		//------------------------------------------------------------------------------
		private var PLAYING_FILENAME:String;
		private var mySound:Sound = new Sound();
		private var mySoundChannel:SoundChannel = new SoundChannel();
		private var cardFlip:cardFlip01 = new cardFlip01();
		
		//Timer
		private var flipTimer:Timer = new Timer(1500,1);
		
		//------------------------------------------------------------------------------
		// Arrayer
		//------------------------------------------------------------------------------
		/**
		 * @memoryArray		Innehåller dubletter av alla kortens movieClips, placeras sedan ut på scenen i initCards();
		 * @randomArray		Är en array som innehåller memoryArrays innehåll men blandar runt siffrorna
		 * @selectedCard	Innehåller de valda korten som användaren tryckt på
		 * @completedPairs	Innehåller de korrekta paren som användaren fått ihop
		 */
		
		private var memoryArray:Array 		= new Array("2","2","3","3","4","4","5","5","6","6","7","7");
		private var randomArray:Array 		= new Array();
		private var selectedCard:Array 		= new Array();
		private var completedPairs:Array 	= new Array();

		//Navigeringsmeny
		private var btn_help:MC_Help = new MC_Help;
		private var btn_exit:MC_Exit = new MC_Exit;
		private var navigation:Array = new Array();
		private var endGame:int = 0; //Kollar om spelet är igång när man vill avsluta.
		
		//Ljudarrayer7
		/* @nabblundVoice Innehåller alla ljuden till spelet
		*/
		
		//private var nabblundVoice:Array = new Array ("NabblundIntro", "NabblundFinished", "cardFlip01", "KimForklaring", "KimNegFeedback02", "KimOutro", "KimPosFeedback01"); 
		
		
		//--------------------------------------------------------------------------
		//	Constructor method
		//--------------------------------------------------------------------------
		
		/**
		 *	Klassens konstruktor.
		 */
		public function Memory() 
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
			initNavigation();
		}
		
		/**
		 *	Metoden aktiverar klassens händelselyssnare.
		 */
		private function initEvents():void
		{
			initFrameArray();
		}
		
		
		//@initNavigation 
		/**
		 *	Metod som lägger in navigationsknapparna i array
		 *	Knapparna placeras sedan ut på scenen och "Touch" egenskaper läggs till
		 */
		private function initNavigation():void
		{
			var btn_exit = new MC_Exit();
			navigation.push(btn_exit);
			
			navigation[0].x = 25;
			navigation[0].y = 25;
			navigation[0].gotoAndStop(1);
			addChild(navigation[0]);
			
			var btn_help = new MC_Help();
			navigation.push(btn_help);
			
			navigation[1].x = stage.stageWidth - (navigation[1].width + 25);
			navigation[1].y = 25;
			navigation[1].gotoAndStop(1);
			addChild(navigation[1]);
			
			navigation[0].addEventListener(TouchEvent.TOUCH_BEGIN, beginExitBtn);
			navigation[0].addEventListener(TouchEvent.TOUCH_OUT, outExitBtn);
			navigation[0].addEventListener(TouchEvent.TOUCH_END, initTownState);
		}
		
		//Funktionen gör så att knappen får en "animation" när den trycks in
		private function beginExitBtn(event:TouchEvent):void
		{
			navigation[0].gotoAndStop(2);
		}
		
		private function outExitBtn(event:TouchEvent):void
		{
			navigation[0].gotoAndStop(1);
		}
		
		//Funktionen gör så att knappen får en "animation" när den trycks in
		private function beginHelpBtn(event:TouchEvent):void
		{
			navigation[1].gotoAndStop(2);
		}
		
		private function outHelpBtn(event:TouchEvent):void
		{
			navigation[1].gotoAndStop(1);
		}
		
		//Funktionen stannar alla ljud som för tillfället spelas upp och spelar istället upp spelförklaringen.
		private function gotoHelp(event:TouchEvent):void
		{
			SoundMixer.stopAll();
			startSound("KimForklaring");
		}
		 /**
		 *	Metoden skapar och lägger in instanser av korten i en array 
		 *  och kallar senare på funktionen som placerar ut korten på scenen.
		 *
		 */
		 	private function initFrameArray():void 
			{					
			
				while(memoryArray.length > 0)
				{
					var i:int = Math.floor(Math.random()*memoryArray.length);
					randomArray.push(memoryArray[i])
					memoryArray.splice(i,1)
				}
	
				trace(randomArray);
				initMemoryArray();
			}
			
			private function initMemoryArray():void 
			{					
				memoryArray.splice(0,memoryArray.length);
			
				for (var i:int = 0; randomArray.length > i; i++)
				{
					var memoryCard:MC_memoryCard = new MC_memoryCard;
					memoryArray.push(memoryCard);
				}
				trace(memoryArray.length)
				initCards();
			}
			/*
			** @initCards placerar ut alla memorybrickor på scenen och placerar dem med deras första keyframe uppåt.
			*/
		
			private function initCards():void
			{
				memoryArray[0].x = 234.35;
				memoryArray[0].y = 94.35;
				memoryArray[0].gotoAndStop(1);
				addChild(memoryArray[0]);

				memoryArray[1].x = 345;
				memoryArray[1].y = 94;
				memoryArray[1].gotoAndStop(1);
				addChild(memoryArray[1]);

				memoryArray[2].x = 461;
				memoryArray[2].y = 97;
				memoryArray[2].gotoAndStop(1);
				addChild(memoryArray[2]);

				memoryArray[3].x = 572;
				memoryArray[3].y = 97;
				memoryArray[3].gotoAndStop(1);
				addChild(memoryArray[3]);

				memoryArray[4].x = 221;
				memoryArray[4].y = 225;
				memoryArray[4].gotoAndStop(1);
				addChild(memoryArray[4]);

				memoryArray[5].x = 343;
				memoryArray[5].y = 225;
				memoryArray[5].gotoAndStop(1);
				addChild(memoryArray[5]);

				memoryArray[6].x = 464;
				memoryArray[6].y = 235;
				memoryArray[6].gotoAndStop(1);
				addChild(memoryArray[6]);
				
				memoryArray[7].x = 581;
				memoryArray[7].y = 235;
				memoryArray[7].gotoAndStop(1);
				addChild(memoryArray[7]);

				memoryArray[8].x = 223;
				memoryArray[8].y = 348;
				memoryArray[8].gotoAndStop(1);
				addChild(memoryArray[8]);

				memoryArray[9].x = 334;
				memoryArray[9].y = 348;
				memoryArray[9].gotoAndStop(1);
				addChild(memoryArray[9]);

				memoryArray[10].x = 457;
				memoryArray[10].y = 348;
				memoryArray[10].gotoAndStop(1);
				addChild(memoryArray[10]);
				
				memoryArray[11].x = 565;
				memoryArray[11].y = 348;
				memoryArray[11].gotoAndStop(1);
				addChild(memoryArray[11]);
				
				initConversation();
			}
			
			/*
			**	@initCardListeners aktiverar touch event på korten samt navigationsknapparna
			**	@removeCardListeners tar bort möjligheten att klicka på korten samt navigationsknapparna
			*/
			private function initCardListeners():void
			{
				memoryArray[0].addEventListener(TouchEvent.TOUCH_TAP, cardTap0);
				memoryArray[1].addEventListener(TouchEvent.TOUCH_TAP, cardTap1);
				memoryArray[2].addEventListener(TouchEvent.TOUCH_TAP, cardTap2);
				memoryArray[3].addEventListener(TouchEvent.TOUCH_TAP, cardTap3);
				memoryArray[4].addEventListener(TouchEvent.TOUCH_TAP, cardTap4);
				memoryArray[5].addEventListener(TouchEvent.TOUCH_TAP, cardTap5);
				memoryArray[6].addEventListener(TouchEvent.TOUCH_TAP, cardTap6);
				memoryArray[7].addEventListener(TouchEvent.TOUCH_TAP, cardTap7);
				memoryArray[8].addEventListener(TouchEvent.TOUCH_TAP, cardTap8);
				memoryArray[9].addEventListener(TouchEvent.TOUCH_TAP, cardTap9);
				memoryArray[10].addEventListener(TouchEvent.TOUCH_TAP, cardTap10);
				memoryArray[11].addEventListener(TouchEvent.TOUCH_TAP, cardTap11);
				navigation[1].addEventListener(TouchEvent.TOUCH_BEGIN, beginHelpBtn);
				navigation[1].addEventListener(TouchEvent.TOUCH_OUT, outHelpBtn);
				navigation[1].addEventListener(TouchEvent.TOUCH_END, gotoHelp);
			}
		
			private function removeCardListeners():void
			{
				memoryArray[0].removeEventListener(TouchEvent.TOUCH_TAP, cardTap0);
				memoryArray[1].removeEventListener(TouchEvent.TOUCH_TAP, cardTap1);
				memoryArray[2].removeEventListener(TouchEvent.TOUCH_TAP, cardTap2);
				memoryArray[3].removeEventListener(TouchEvent.TOUCH_TAP, cardTap3);
				memoryArray[4].removeEventListener(TouchEvent.TOUCH_TAP, cardTap4);
				memoryArray[5].removeEventListener(TouchEvent.TOUCH_TAP, cardTap5);
				memoryArray[6].removeEventListener(TouchEvent.TOUCH_TAP, cardTap6);
				memoryArray[7].removeEventListener(TouchEvent.TOUCH_TAP, cardTap7);
				memoryArray[8].removeEventListener(TouchEvent.TOUCH_TAP, cardTap8);
				memoryArray[9].removeEventListener(TouchEvent.TOUCH_TAP, cardTap9);
				memoryArray[10].removeEventListener(TouchEvent.TOUCH_TAP, cardTap10);
				memoryArray[11].removeEventListener(TouchEvent.TOUCH_TAP, cardTap11);
				navigation[0].removeEventListener(TouchEvent.TOUCH_BEGIN, beginExitBtn);
				navigation[0].removeEventListener(TouchEvent.TOUCH_OUT, outExitBtn);
				navigation[0].removeEventListener(TouchEvent.TOUCH_END, initTownState);
			}
			
			/* 
			**	@initConversation Placerar ut karaktärerna på scenen och kollar om endgame == 0 fortsätter
			**	spelet som vanligt men om endGame == 1 så har användaren tryckt på tillbaka knappen och spelet avslutas
			**
			** @initConversation2 sitter på ett timeEvent som startar Kims introduktion efter att Fröken Näbblund har pratat klart.
			*/
		
		private function initConversation():void 
		{
			Kim.x		= 595;
			Kim.y		= 260;
			Kim.gotoAndStop(1);
			addChild(Kim);
			
			Nabblund.x 	= -13;
			Nabblund.y	= 105,35;
			Nabblund.gotoAndPlay(1);
			addChild(Nabblund);
			
			if (endGame == 0)
			{
				startSound("NabblundIntro");
				
				var dynamicTalkTimer:Timer = new Timer(1000,10);
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, initConversation2);
			}
			
			else if(endGame == 1)
			{
				SoundMixer.stopAll();
				//dynamicTalkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, initConversation2);
				return;
			}
		}
		
		private function initConversation2(event:TimerEvent):void
		{			
			if (endGame == 0)
			{
				Nabblund.gotoAndStop(1);
				Kim.gotoAndPlay(1);
				startSound("KimForklaring");
				
				var dynamicTalkTimer:Timer = new Timer(1000,7);	
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopIntroConversation);
			}
			
			else if (endGame == 1)
			{
				SoundMixer.stopAll();
				//dynamicTalkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopIntroConversation);
				return;
			}
		}
		
		/*
		** @KimNegativeFeedback startas om användaren klickat på två olika memorybrickor, då startas en animation
		** på Kim samt ett feedbackljud.
		*/
		private function KimNegativeFeedback():void
		{
			var randomKim:int = Math.floor(Math.random() * 3);
			if (endGame == 0) // Om "endGame" är 1 betyder det att användaren har tryckt på avsluta-knappen.
			{
				
			if (randomKim == 2)
				{
					startSound("KimNegFeedback02");
					Kim.gotoAndPlay(1);
					var dynamicTalkTimer:Timer = new Timer(1000,6);
					dynamicTalkTimer.reset();
					dynamicTalkTimer.start();
					dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopConversation);
				}
				
			}
			
			else if(endGame == 1)
			{
				SoundMixer.stopAll();
				//dynamicTalkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopConversation);
				return;
			}
		}
		
		/*
		** @KimPositiveFeedback startas om användaren klickat på två likadana memorybrickor, då startas en animation
		** på Kim samt ett feedbackljud som är sex sekunder långt och det är så länge som animationen på Kim håller på.
		*/
		private function KimPositiveFeedback():void
		{
			if (endGame == 0)
			{
				Kim.gotoAndPlay(1);
				startSound("KimPosFeedback01");
				
				var dynamicTalkTimer:Timer = new Timer(1000,6);
				dynamicTalkTimer.reset();
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopConversation);
			}
			
			else if (endGame == 1)
			{
				SoundMixer.stopAll();
				//dynamicTalkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopConversation);	
				return;
			}

		}
		
		/*
		**	@delmomentSound spelar upp en ljudsnutt som indikerar att användaren hittat ett par.
		*/
		private function delmomentSound():void
		{
			if (endGame == 0)
			{
				startSound("avklaratDelmoment");
			}
			
			else if (endGame == 1)
			{
				SoundMixer.stopAll();
				return;
			}
		}
		/*
		**	@finishedSound spelar upp ett slutljud när användaren har klarat av spelet.
		**
		*/
		private function finishedSound():void
		{
			if (endGame == 0)
			{
				startSound("vinst");
			}
			
			else if (endGame == 1)
			{
				SoundMixer.stopAll();
				return;
			}
		}
		
		/*
		**	@stopConversation sätter karaktärerna Kim och Näbblund till deras första keyframe, alltså deras animation stannar.
		*/
		private function stopConversation(event:TimerEvent):void
		{
			Nabblund.gotoAndStop(1);
			Kim.gotoAndStop(1);
		}
		
		/*
		**	@stopIntroConversation kallas efter att introduktionen har startas och då anropar vi funktionen
		**	initCardListeners som startar touchEventet på alla memorybrickorna.
		*/
		private function stopIntroConversation(event:TimerEvent):void
		{
			Nabblund.gotoAndStop(1);
			Kim.gotoAndStop(1);
			initCardListeners();
		}
		
		/*
		**	@NabblundOutro anropas om arrayen completedPairs.length == 12 alltså om alla memorybrickor är tagna
		**	skall Näbblund spela upp ljudet NabblundFinished och göra en animation i nio sekunder. Samt att funktionen outroConversation kallas
		*/
		private function NabblundOutro():void
		{			
			if (endGame == 0) // Om "endGame" är 1 betyder det att användaren har tryckt på avsluta-knappen.
			{
				Nabblund.gotoAndPlay(1);
				startSound("NabblundFinished");
				
				var dynamicTalkTimer:Timer = new Timer(1000,9);
				dynamicTalkTimer.reset();
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, outroConversation);
			}
			
			else
			{
				SoundMixer.stopAll();
				dynamicTalkTimer.stop();
				dynamicTalkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, outroConversation);
				return;
			}
		}
		/*
		**	@outroConversation kallas via ett timeEvent i funktionen nabblundOutro. 
		**	Funktionen startar ljudet KimOutro samt sätter en animation till ljudet. 
		*/
		private function outroConversation(event:TimerEvent):void 
		{
			Nabblund.gotoAndStop(1);
			Kim.gotoAndPlay(1);
			
			if (endGame == 0) // Om "endGame" är 1 betyder det att användaren har tryckt på avsluta-knappen.
			{
				startSound("KimOutro");
				
				var dynamicTalkTimer:Timer = new Timer(1000,9);
				dynamicTalkTimer.reset();
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, clearedMemoryGame);
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopConversation);
			}
			
			else
			{
				SoundMixer.stopAll();
				dynamicTalkTimer.stop();
				dynamicTalkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, clearedMemoryGame);
				dynamicTalkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopConversation);
				return;
			}
		}
		
			//END KONVERSATION
			
			
			/*
			**	@ cardTap Om en användare trycker på en memorybricka skall den brickan sparas i selectedCard array som skall kolla av om nästa kort passar
			**	och isåfall genererar ett positivt ljud samt feedback och sedan spliceas korten ut ur arrayen selectedCard. Om användaren väljer två olika kort skall 
			**	den få ett negativt ljud samt feedback att försöka igen. selectedCard arrayen är alltså en temporär placeholder för de valda korten.
			**	När användaren trycket på ett kort så vänds det kortet och ett cardFlip ljud spelas upp.
			*/
			
			private function cardTap0(event:TouchEvent):void
			{
				selectedCard.push(randomArray[0]);
				memoryArray[0].gotoAndStop(randomArray[0]);
				cardFlip.play();
				memoryArray[0].removeEventListener(TouchEvent.TOUCH_TAP, cardTap0);
				
				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap1(event:TouchEvent):void
			{
				selectedCard.push(randomArray[1]);
				memoryArray[1].gotoAndStop(randomArray[1]);
				cardFlip.play();
				memoryArray[1].removeEventListener(TouchEvent.TOUCH_TAP, cardTap1);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap2(event:TouchEvent):void
			{
				selectedCard.push(randomArray[2]);
				memoryArray[2].gotoAndStop(randomArray[2]);
				cardFlip.play();
				memoryArray[2].removeEventListener(TouchEvent.TOUCH_TAP, cardTap2);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap3(event:TouchEvent):void
			{
				selectedCard.push(randomArray[3]);
				memoryArray[3].gotoAndStop(randomArray[3]);
				cardFlip.play();
				memoryArray[3].removeEventListener(TouchEvent.TOUCH_TAP, cardTap3);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}			
			
			private function cardTap4(event:TouchEvent):void
			{
				selectedCard.push(randomArray[4]);
				memoryArray[4].gotoAndStop(randomArray[4]);
				cardFlip.play();
				memoryArray[4].removeEventListener(TouchEvent.TOUCH_TAP, cardTap4);
				
				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap5(event:TouchEvent):void
			{
				selectedCard.push(randomArray[5]);
				memoryArray[5].gotoAndStop(randomArray[5]);
				cardFlip.play();
				memoryArray[5].removeEventListener(TouchEvent.TOUCH_TAP, cardTap5);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap6(event:TouchEvent):void
			{
				selectedCard.push(randomArray[6]);
				memoryArray[6].gotoAndStop(randomArray[6]);
				cardFlip.play();
				memoryArray[6].removeEventListener(TouchEvent.TOUCH_TAP, cardTap6);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap7(event:TouchEvent):void
			{
				selectedCard.push(randomArray[7]);
				memoryArray[7].gotoAndStop(randomArray[7]);
				cardFlip.play();
				memoryArray[7].removeEventListener(TouchEvent.TOUCH_TAP, cardTap7);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap8(event:TouchEvent):void
			{
				selectedCard.push(randomArray[8]);
				memoryArray[8].gotoAndStop(randomArray[8]);
				cardFlip.play();
				memoryArray[8].removeEventListener(TouchEvent.TOUCH_TAP, cardTap8);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap9(event:TouchEvent):void
			{
				selectedCard.push(randomArray[9]);
				memoryArray[9].gotoAndStop(randomArray[9]);
				cardFlip.play();
				memoryArray[9].removeEventListener(TouchEvent.TOUCH_TAP, cardTap9);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap10(event:TouchEvent):void
			{
				selectedCard.push(randomArray[10]);
				memoryArray[10].gotoAndStop(randomArray[10]);
				cardFlip.play();
				memoryArray[10].removeEventListener(TouchEvent.TOUCH_TAP, cardTap10);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			private function cardTap11(event:TouchEvent):void
			{
				selectedCard.push(randomArray[11]);
				memoryArray[11].gotoAndStop(randomArray[11]);
				cardFlip.play();
				memoryArray[11].removeEventListener(TouchEvent.TOUCH_TAP, cardTap11);

				if (selectedCard.length == 2)
				{
					flipTimer.reset();
					flipTimer.start();
					removeCardListeners();
					flipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flipBack);
				}
			}
			
			
			/*
			**	@rightOrWrong Funktionen kollar av om man lyckats få ihop ett par och sparar isåfall paret i arrayen completedPairs.
			**	Om man valt fel par så vänds brickorna tillbaka och användaren får försöka på nytt.
			**
			** 	@if (completedPairs.length == 2,6,12) om completedPairs.length är lika med 2 eller 6 så spelas positiv feedback 
			**	upp till användaren och om completedPairs.length == 12 så har man klarat spelet och funktionen nabblundOutro kallas.
			**
			**	@else if (selectedCard[0] != selectedCard[1]) Ifall korten inte stämmer överens med varandra så vänds just dem tillbaka till baksidan uppåt (frame 1).
			**
			**	@if (memoryArray[i].currentFrame == selectedCard[0]) kollar om memoryArray labeln är densamma som selectedCard labeln.
			**	om den är det så läggs en ny instans av movieclipet ut och den instanser är statiskt och går inte att klicka på. 
			*/
			
			private function rightOrWrong():void
			{		
				//Ifall kortparet du valt är ett korrekt par.
				if (selectedCard[0] == selectedCard[1])
				{				
					if (completedPairs.length < 10)
					{
					delmomentSound();
					}
					
					for (var i:int = 0; memoryArray.length > i; i++)
					{												
						if (memoryArray[i].currentFrame == selectedCard[0])
						{
							var memoryCard:MC_memoryCard = new MC_memoryCard;
								memoryCard.x = memoryArray[i].x;
								memoryCard.y = memoryArray[i].y;
								memoryCard.gotoAndStop(selectedCard[0]);
								addChild(memoryCard);
								
							removeChild(memoryArray[i])
							completedPairs.push(1);
							selectedCard.splice(0,1);
							trace(completedPairs);
							if (completedPairs.length == 2)  
							{
								KimPositiveFeedback();			
							}
					
							if (completedPairs.length == 6)  
							{
								KimPositiveFeedback();			
							}
					
							if (completedPairs.length == 12)  
							{
								finishedSound();
								NabblundOutro();
							}
						}
					}
				}
				
				else if (selectedCard[0] != selectedCard[1])
				{
					KimNegativeFeedback();
					for (var d:int = 0; memoryArray.length >d; d++)
					{		
						if (memoryArray[d].currentFrame == selectedCard[0] || selectedCard[1])
						{
							memoryArray[d].gotoAndStop(1);
						}
					}
				}
				selectedCard.splice(0,selectedCard.length);
			}
				
			/*
			**	@flipBack flipBack kallas i varje cardTap funktion och kör rightOrWrong funktionen som kollar av om memorykorten är lika.
			**	När två kort är uppvändna så removeas eventlyssnarna på alla de andra korten så att man inte kan klicka på massa kort samtidigt
			**	sedan körs fliBack som kör funktionen rightOrWrong som kollar om de är rätt och sätter sedan tillbaka eventlyssnaren på korten.
			*/
			private function flipBack(event:TimerEvent):void
			{
				rightOrWrong();
				initCardListeners();
			}
				
				
				
		//START SOUND
		/*
		 **	 @startSound	Laddar in en extern mp3-fil enligt sökvägen "sounds/ + filename + .mp3".
		 ** 
		 */
			
			private function startSound(SOUND_NAME):void
			{
				var PLAYING_FILENAME = SOUND_NAME;
				mySoundChannel.stop();
				var snd:Sound = new Sound();
				var req:URLRequest = new URLRequest("Ljud/Memory/" + SOUND_NAME + ".mp3");
				snd.addEventListener(Event.COMPLETE, soundLoaded);
				snd.load(req);
			}
		/**
		 *	@soundLoaded	Spelar upp ljudet efter det har laddats in och lokaliserats på "disken".
		 *  Påbörjar sedan uppspelningen i SoundChanneln: "mySoundChannel"
		 *
		 */
			
			private function soundLoaded(event:Event):void 
			{
				var theSound:Sound = event.target as Sound;
				mySoundChannel = theSound.play();
			}
		
		//END SPELET
		//------------------------------------------------------------------------------
		//  Avklarat spel / Återgå till meny
		//------------------------------------------------------------------------------
		/**
		 * @clearedMemoryGame	Då ett helt spel av Memory är genomfört korrekt så startas denna avslutande funktion med tal och användaren skickas tillbaka till huvudmenyn.
		 * @newState(Menu)	Återgår till Menu-tillståndet (Huvudmenyn), efter avklarad spelomgång.
		 * @initTownState	Aktiverar Menu-tillståndet vid klick på hemknappen. "endGame" ändras till "1" för att avbryta ljud.
		 */
			
			
		/**
		 *	Metoden aktiverar Menu-tillståndet.
		 * 
		 *	@return void
		 */
		private function initTownState(event:TouchEvent):void
		{
			endGame = 1;
			newState(Menu);
		}
		
		private function clearedMemoryGame(event:TimerEvent):void
		{
			newState(Menu);
		}
		
	}
}