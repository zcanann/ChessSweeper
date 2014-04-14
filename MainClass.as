package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.display.BitmapData;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	//Manages loading, menus, and so on
	public class MainClass extends MovieClip
	{
		private var AppStage : Stage; 		//Pointer to stage
		private var Game : GameClass;				//Game class instance
		
		private var MainMenuBackGround : MainMenuBackGroundClass = new MainMenuBackGroundClass();
		private var Title : TitleClass = new TitleClass();
		private var StartAIMatchButton : Button = new Button();
		private var StartPlayerMatchButton : Button = new Button();
		
		private var _AppFont = new AppFont(); 
		
		public function MainClass(AppStage : Stage)
		{
			this.AppStage = AppStage;
			
			var Format : TextFormat = new TextFormat();
			Format.font = _AppFont;
			Format.size = 32;
			
			Title.x = AppStage.stageWidth/2 - Title.width/2;
			Title.y = 96;
			
			StartAIMatchButton.label = "Play";
			StartAIMatchButton.setStyle("textFormat", Format);
			StartAIMatchButton.width = 256;
			StartAIMatchButton.height = 48;
			StartAIMatchButton.x = AppStage.stageWidth / 2 - StartAIMatchButton.width / 2;
			StartAIMatchButton.y = AppStage.stageHeight / 4;
			
			StartPlayerMatchButton.label = "2 Player Match";
			StartPlayerMatchButton.setStyle("textFormat", Format);
			StartPlayerMatchButton.width = 256;
			StartPlayerMatchButton.height = 48;
			StartPlayerMatchButton.x = AppStage.stageWidth / 2 - StartAIMatchButton.width / 2;
			StartPlayerMatchButton.y = StartAIMatchButton.y + StartAIMatchButton.height + 24;
			
			Load();
		}
		
		public function Load() : void
		{
			AppStage.addChild(MainMenuBackGround);
			AppStage.addChild(Title);
			AppStage.addChild(StartAIMatchButton);
			//AppStage.addChild(StartPlayerMatchButton);
			StartAIMatchButton.addEventListener(MouseEvent.CLICK, StartAIMatch);
			StartPlayerMatchButton.addEventListener(MouseEvent.CLICK, StartPlayerMatch);
		}
		
		//Externally called by the menus to start an AI Game. TODO: AI parameters
		public function StartAIMatch(e : MouseEvent) : void
		{
			//CleanUp();
			StartPlayerMatch(e);
		}
		
		//Externally called by menus to start a campaign game
		public function StartPlayerMatch(e : MouseEvent) : void
		{
			CleanUp();
			Game = new GameClass(AppStage, this);
		}
		
		private function CleanUp() : void
		{
			StartAIMatchButton.removeEventListener(MouseEvent.CLICK, StartAIMatch);
			StartPlayerMatchButton.removeEventListener(MouseEvent.CLICK, StartPlayerMatch);
			AppStage.removeChild(MainMenuBackGround);
			AppStage.removeChild(StartAIMatchButton);
			//AppStage.removeChild(StartPlayerMatchButton);
			AppStage.removeChild(Title);
		}

	} //End class
	
} //End package