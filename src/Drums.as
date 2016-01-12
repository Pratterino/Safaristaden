package  
{		
	//------------------------------------------------------------------------------
	//  Imports
	//------------------------------------------------------------------------------	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
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
	public class Drums extends State
	{
		//------------------------------------------------------------------------------
		// Globala definitioner & variablar
		//------------------------------------------------------------------------------
		//MovieClips
		private var drumYellow:MC_drumYellow = new MC_drumYellow;
		private var drumRed:MC_drumRed = new MC_drumRed;
		private var drumBlue:MC_drumBlue = new MC_drumBlue;
		private var drumGreen:MC_drumGreen = new MC_drumGreen;
		private var currentNote:MC_Note = new MC_Note;
		private var drumRings:MC_drumRings = new MC_drumRings;
		private var bosseHund:MC_BosseHund = new MC_BosseHund;
		private var Kim:MC_KimTalk= new MC_KimTalk;
		
		//Navigeringsmeny
		private var btn_help:MC_Help = new MC_Help;
		private var btn_exit:MC_Exit = new MC_Exit;
		private var navigation:Array 		= new Array();
		private var endGame:int = 0; //Kollar om spelet är igång när man vill avsluta.
		
		//Variablar, Timers & Strängar
		private var whichDrum:int;
		private var simonLength:int = 4; //Antal toner som varje spel ska bestå av.
		private var timer:Timer = new Timer(1500,1);
		private var SimonTimer:Timer = new Timer(1000,1);
		private var delayTimer:Timer = new Timer(1000,1);
		private var s:int = 0;
		
		//Ljud
		private var PLAYING_FILENAME:String;
		private var mySound:Sound = new Sound();
		private var mySoundChannel:SoundChannel = new SoundChannel();
		
		//------------------------------------------------------------------------------
		// Arrayer
		//------------------------------------------------------------------------------
		/**
		 *	@drumArray			Innehåller alla trummornas movieClips, placeras sedan ut på scenen i initDrums();
		 *  @simonSays			Innehåller fyra slumpvist valda nummer, som används för den automatiska uppspelningen av trummor och skapar ordningen.
		 *  @currentNoteArray	Har bara en position: currentNoteArray[0], för att visa upp den aktuella noten/trummans färg högst uppe.
		 *  @showDrums			Används för att skapa trumindikatorn nere i mitten på skärmen. Visar upp vilka trummor som är tagna och hur många som saknas.
		 * 
		 *  @bossePosFeedback	Innehåller två variationer av strängar som länkar till två olika ljudfiler samt två tysta ljudfiler. 
		 * 						Ett slumpt av dessa spelas upp vid korrekt trumslag.
		 * 
		 */
		
		//Simon Says
		private var drumArray:Array 		= new Array(drumYellow, drumRed, drumBlue, drumGreen);
		private var simonSays:Array 		= new Array();
		private var currentNoteArray:Array 	= new Array();
		private var showDrums:Array			= new Array();
		
		//Ljudarrayer
		private var bossePosFeedback:Array 	= new Array("none", "BossePosFeedback01", "none", "BossePosFeedback02", "none");
		
		//--------------------------------------------------------------------------
		//	Konstruktor
		//--------------------------------------------------------------------------
		public function Drums() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//--------------------------------------------------------------------------
		//	Private methods
		//--------------------------------------------------------------------------
		
		/**
		 *	Då allting är tömt och denna klassfilen är inläst - så initieras alla objekt på scenen.
		 * 
		 *  @initDrums			Lägger ut trummorna på scenen.
		 *  @initShowDrums		Lägger ut trummindikatorn längst nere på skärmen.
		 *  @initConversation	Initierar den första konversationen med Bosse Hund. Denna funktionen är sammankopplad och spelar upp hela introduktions konversationerna automatiskt löpande.
		 *  @initNavigation		initierar lyssning på navigationsknapparna och lägger ut dem på scenen.
		 * 
		 */
		
		private function init(event:Event = null):void
		{
			initDrums();
			initShowDrums();
			initConversation();
			initNavigation();
		}
		
		//NAVIGATION BEGIN
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
		
		private function beginExitBtn(event:TouchEvent):void
		{
			navigation[0].gotoAndStop(2);
		}
		
		private function outExitBtn(event:TouchEvent):void
		{
			navigation[0].gotoAndStop(1);
		}	
				
		private function beginHelpBtn(event:TouchEvent):void
		{
			navigation[1].gotoAndStop(2);
		}
		
		private function outHelpBtn(event:TouchEvent):void
		{
			navigation[1].gotoAndStop(1);
		}		
		
		private function gotoHelp(event:TouchEvent):void
		{
			if (endGame == 0)
			{
				SoundMixer.stopAll();
				startSound("KimForklaring");
				Kim.gotoAndPlay(1);
				
				var dynamicTalkTimer:Timer = new Timer(1000,8);
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimerConversation);
			}
		}
		
		//NAVIGATION END	
		private function initShowDrums():void 
		{
			var xSlider = 325;		
			
			for (var b:int = 0; b < simonLength; b++) 
			{
				var drumRings = new MC_drumRings;
				drumRings.gotoAndStop(1);
				showDrums.push(drumRings);
				
				showDrums[b].x = xSlider;
				showDrums[b].y = 400;
				
				addChild(showDrums[b]);
				xSlider += 35;	
			}
		}
		
		private function initDrums():void
		{
			//ÖVERSTA
			drumArray[0].x = 330;
			drumArray[0].y = 90;
			drumArray[0].gotoAndStop(1);
			addChild(drumArray[0]);
			
			//HÖGRA
			drumArray[1].x = 520;
			drumArray[1].y = 147;
			drumArray[1].gotoAndStop(1);
			addChild(drumArray[1]);
			
			//NEDERSTA
			drumArray[2].x = 315;
			drumArray[2].y = 240;
			drumArray[2].gotoAndStop(1);
			addChild(drumArray[2]);
			
			//VÄNSTRA
			drumArray[3].x = 130;
			drumArray[3].y = 145;
			drumArray[3].gotoAndStop(1);
			addChild(drumArray[3]);
		}
		
		private function initDrumListeners():void
		{
			drumArray[0].addEventListener(TouchEvent.TOUCH_TAP, drumTap0);
			drumArray[1].addEventListener(TouchEvent.TOUCH_TAP, drumTap1);
			drumArray[2].addEventListener(TouchEvent.TOUCH_TAP, drumTap2);
			drumArray[3].addEventListener(TouchEvent.TOUCH_TAP, drumTap3);
			navigation[1].addEventListener(TouchEvent.TOUCH_BEGIN, beginHelpBtn);
			navigation[1].addEventListener(TouchEvent.TOUCH_OUT, outHelpBtn);
			navigation[1].addEventListener(TouchEvent.TOUCH_END, gotoHelp);
			addEventListener(Event.ENTER_FRAME, checkFinished);
		}
		
		private function removeDrumListeners():void
		{
			drumArray[0].removeEventListener(TouchEvent.TOUCH_TAP, drumTap0);
			drumArray[1].removeEventListener(TouchEvent.TOUCH_TAP, drumTap1);
			drumArray[2].removeEventListener(TouchEvent.TOUCH_TAP, drumTap2);
			drumArray[3].removeEventListener(TouchEvent.TOUCH_TAP, drumTap3);
			navigation[1].removeEventListener(TouchEvent.TOUCH_BEGIN, beginHelpBtn);
			navigation[1].removeEventListener(TouchEvent.TOUCH_OUT, outHelpBtn);
			navigation[1].removeEventListener(TouchEvent.TOUCH_END, gotoHelp);
			removeEventListener(Event.ENTER_FRAME, checkFinished);
		}
		
		//KONVERSATION
		private function initConversation():void 
		{
			Kim.x		= 595;
			Kim.y		= 260;
			Kim.gotoAndStop(1);
			addChild(Kim);
			
			bosseHund.x = 25;
			bosseHund.y	= 260;
			addChild(bosseHund);			
			
			if (endGame == 0) // Om "endGame" är 1 betyder det att användaren har tryckt på avsluta-knappen.
			{
				startSound("BosseIntro");
				
				var dynamicTalkTimer:Timer = new Timer(1000,8);
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, initConversation2);
			}
			
			else if (endGame == 1)
			{
				SoundMixer.stopAll();
				return;
			}	
		}
		
		private function initConversation2(event:TimerEvent):void
		{
			bosseHund.gotoAndStop(1);
			Kim.gotoAndPlay(1);
			
			if (endGame == 0)
			{
				startSound("KimForklaring");
				
				var dynamicTalkTimer:Timer = new Timer(1000,8);
				dynamicTalkTimer.reset();	
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, initSimonSays);
			}
			
			else if (endGame == 1)
			{
				SoundMixer.stopAll();
				return;
			}
		}
		
		private function stopConversation():void
		{
			bosseHund.gotoAndStop(1);
			Kim.gotoAndStop(1);
		}
		
		private function stopTimerConversation(event:TimerEvent):void
		{
			bosseHund.gotoAndStop(1);
			Kim.gotoAndStop(1);
		}
		
		private function outroConversation(event:TimerEvent):void 
		{
			if (endGame == 0)
			{
				Kim.gotoAndPlay(1);
				startSound("KimOutro");
				
				navigation[0].removeEventListener(TouchEvent.TOUCH_BEGIN, beginExitBtn);
				navigation[0].removeEventListener(TouchEvent.TOUCH_OUT, outExitBtn);
				navigation[0].removeEventListener(TouchEvent.TOUCH_END, initTownState);
				removeDrumListeners();
				
				var dynamicTalkTimer:Timer = new Timer(1000,4);
				dynamicTalkTimer.reset();
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, clearedGame);
			}
			
			else if (endGame == 1)
			{
				SoundMixer.stopAll();
				dynamicTalkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, clearedGame);
				return;
			}
			
		}
		//END KONVERSATION
		
		//SPELKOD
		/**
		 * Här är självaste spelets kod, spelregler och vad som sker efter att inledande 
		 * konversation skett och allt lagts ut på scenen.
		 * 
		 * @initSimonSays		Stoppar konversationens animationer och skapar sedan fyra slumpvist valda siffror
		 * 						som används för att skapa spelomgångens dynamiska ordningsföljd.
		 * 
		 */
		private function initSimonSays(event:TimerEvent):void
		{
			stopConversation();
			
			for (var a:int = 0; a < simonLength; a++) 
			{
				simonSays.push(Math.floor(Math.random() * simonLength))
			}
			
			simonPlayDrums();
		}
		
		private function simonPlayDrums():void
		{			
			removeDrumListeners();
			SimonTimer.reset();
			SimonTimer.start();
			SimonTimer.addEventListener(TimerEvent.TIMER_COMPLETE, simonCurrent);
		}
		
		private function simonCurrent(event:TimerEvent):void
		{	
			if (endGame == 0)
			{
				/**
				 * Ifall "s" uppnåt samma tal som "simonLength" så är det färdiguppspelat. Då ratureneras och initieras TOUCH.POINT-lyssnarna i funktionen "simonPlayDone()".
				 */
				if (s == simonLength)
				{
					simonPlayDone();
					return;
				}
				
				/**
				 * Annars så är spelat fortfarande aktivt - då utförs en kort delay innan nästa trumma lyses/spelas upp.
				 */
				else
				{
					addNote(s);
					drumArray[simonSays[s]].gotoAndStop(2);
					startSound("drum" + simonSays[s]);
					trace("s = " + s);
					s++;
					
					delayTimer.reset();
					delayTimer.start();
					delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayTimerFunc);
				}		
			}
		}
		
		/**
		 * @addnote		Visar den aktuella trummans färg i noten längst upp på rutan.
		 * 
		 */
		
		private function addNote(currentColor):void
		{
			var currentNote			= new MC_Note;
			currentNote.x 		= stage.stageWidth/2;
			currentNote.y 		= 15;
			currentNoteArray[0] = currentNote;
			currentNote.gotoAndStop(simonSays[currentColor]+1);
			addChild(currentNoteArray[0]);
		}
		
		/**
		 * @delayTimerFunc		Släcker (alla) trummorna efter att de automatiskt spelat upp vid initierat spel.
		 * @removeChild			Släcker den lilla färgnoten på toppen av skärmen samtidigt som trummorna släcks.
		 * @simonPlayDrums		Återgår till funktionen och spelar nu upp nästa trumma i arrayen, som ska spelas upp. 
		 * 
		 */
		private function delayTimerFunc(event:TimerEvent):void
		{
			for (var i:int = 0; i < simonSays.length; i++)
			{
				drumArray[i].gotoAndStop(1);
			}
			
			removeChild(currentNoteArray[0]);
			simonPlayDrums();
		}
		
		/**
		 * @s=0					Nollställer trumräknaren "s" till 0 för att försäkra om att spelet är slut och kan spelas om igen om så önskas.
		 * 
		 * @initDrumListeners	Initierar lyssnare för tryck på trummor efter den automatiska uppspelningen är klar, så det inte är möjligt att 
		 * 						klicka under uppspelning.
		 * 
		 */
		private function simonPlayDone():void
		{
			s = 0;
			drumArray[simonSays[simonSays.length-1]].gotoAndStop(1);
			
			initDrumListeners();
		}
		//END SPELET
		
		//START SOUND
		/**
		 * @startSound		Laddar in en extern mp3-fil enligt sökvägen "sounds/ + filename + .mp3".
		 * 
		 */
		private function startSound(SOUND_NAME):void
		{
			var PLAYING_FILENAME = SOUND_NAME;
			trace("PLAYING_FILENAME startSound: " + PLAYING_FILENAME);
			
			SoundMixer.stopAll();
			mySoundChannel.stop();
			var snd:Sound = new Sound();
			var req:URLRequest = new URLRequest("Ljud/Drums/" + PLAYING_FILENAME + ".mp3");
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
		 *  Lyssnar efter vilken trumma som blir träffad och ändrar nummervariabeln "whichDrum" till motsvarande trumnummer. 
		 *  Detta nummer kontrollerar i funktionen "youPlayDrum()" ifall detta trumtryck stämmer överens med den dynamiska ordningsföljden.
		 *  
		 */
		//ÖVERSTA
		private function drumTap0(event:TouchEvent):void
		{
			drumArray[0].gotoAndStop(2);
			whichDrum = 0;
			youPlayDrum();
			drumFader();
			startSound("drum0");
		}
		//HÖGRA
		private function drumTap1(event:TouchEvent):void
		{
			drumArray[1].gotoAndStop(2);
			whichDrum = 1;
			youPlayDrum();
			drumFader();
			startSound("drum1");
		}
		//NEDERSTA
		private function drumTap2(event:TouchEvent):void
		{
			drumArray[2].gotoAndStop(2);
			whichDrum = 2;
			youPlayDrum();
			drumFader();
			startSound("drum2");
		}
		//VÄNSTRA
		private function drumTap3(event:TouchEvent):void
		{
			drumArray[3].gotoAndStop(2);
			whichDrum = 3;
			youPlayDrum();
			drumFader();
			startSound("drum3");
		}
		
		/**
		 * 
		 * @drumFader		Släcker trumman (alla trummor) som är tryckt på, så att de återgår till dess ursprungliga utgångsläge
		 * 					Där de är otända/släckta. TOUCH-lyssnarna tas bort så att användaren måste vänta på att trumman släcks.
		 * 
		 * @tickComplete	Nollställer trummorna till det släckta läget. Initierar även lyssnarna så att trummorna blir spelbara.
		 * 					Trummorna tppar lyssnarna tack vare "drumFader", återför klickabarheten efter att drumFader's timer har tickat klart.			
		 * 
		 * @youPlayDrum		Kontrollerar ifall den trumman som användaren tryckt på (whichDrum), 
		 * 					stämmer överens med den som ligger först i tur (simonSays[0]).
		 * 
		 * @randomBossePos	Spelar upp slumpvist vald positiv feedback från Bosse. Finns med tysta spår i "bossePosFeedback"-arrayen,
		 * 					för att inte konstant få feedback - då det skulle vara väldigt frustrerande att lyssna på de två klippen hela tiden.
		 * 					
		 * @else			Ifall trumman som användaren klickat på inte stämmer överens med "simonSays[0]", så säger Kim:
		 * 					"- Attans! Nära men inte riktigt, försök igen".
		 */
		private function drumFader():void
		{
			removeDrumListeners();
			timer.reset();
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, tickComplete);
		}
		
		private function tickComplete(event:TimerEvent):void
		{
			drumArray[whichDrum].gotoAndStop(1);
			
			for (var i:int = 0; i < drumArray.length; i++)
			{
				drumArray[i].gotoAndStop(1);
			}
			
			initDrumListeners();
		}
		
		private function youPlayDrum():void
		{
			if (endGame == 0)
			{
				if (whichDrum == simonSays[0])
			
				{
					showDrums[showDrums.length - simonSays.length].gotoAndStop(whichDrum+2);
					simonSays.splice(0,1);
					
					var randomBossePos = Math.floor(Math.random() * bossePosFeedback.length);
					startSound(bossePosFeedback[randomBossePos]);
					
					if (bossePosFeedback[randomBossePos] != "none")
					{
						bosseHund.gotoAndPlay(1);
						var dynamicTalkTimer:Timer = new Timer(1050,1);
						dynamicTalkTimer.start();
						dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimerConversation);
					}
				}
					
				else
				{
					Kim.gotoAndPlay(1);
					startSound("KimNegFeedback");
					var dynamicTalkTimer1:Timer = new Timer(1000,4);
					dynamicTalkTimer1.reset();
					dynamicTalkTimer1.start();
					dynamicTalkTimer1.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimerConversation);
				}
			}
			
			else if (endGame == 1)
			{
				
			}
		}
		
		//------------------------------------------------------------------------------
		//  Kontroll av avklarat spelomgång
		//------------------------------------------------------------------------------
		/**
		 * @checkFinished	Kontrollerar ifall arrayen "simonSays" längd är splicad (tagen) och är tom
		 * 					Är den tom - så är spelet klart.
		 * 
		 */
		private function checkFinished(event:Event):void
		{
			if (simonSays.length == 0)
			{
				removeDrumListeners();
				
				startSound("vinst");
				var dynamicTalkTimer:Timer = new Timer(1000,3);
				dynamicTalkTimer.reset();
				dynamicTalkTimer.start();
				dynamicTalkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, outroConversation);
			}
		}
		
		
		//------------------------------------------------------------------------------
		//  Avklarat spel / Återgå till meny
		//------------------------------------------------------------------------------
		/**
		 * @clearedGame		Då ett helt spel av Simon Says är genomfört korrekt så startas denna avslutande funktion med tal.
		 * @newState(Menu)	Återgår till Menu-tillståndet (Huvudmenyn), efter avklarad spelomgång.
		 * @simonLength		Kan användas för att initiera ett nytt spel med önskad längd av trumspelning.
		 * @initTownState	Aktiverar Menu-tillståndet vid klick på hemknappen. "endGame" ändras till "1" för att avbryta ljud.
		 */
		private function clearedGame(event:TimerEvent):void
		{
			SoundMixer.stopAll();
			newState(Menu); //Återgår till huvudmenyn.
		}
		
		private function initTownState(event:TouchEvent):void
		{
			endGame = 1;
			SoundMixer.stopAll();
			newState(Menu);
		}
	}
}