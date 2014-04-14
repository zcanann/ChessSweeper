package 
{
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.display.BlendMode;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.geom.Vector3D;
	import flash.display.BitmapData;
	
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	//Manages various game elements - game itself, ingame menus, UI, etc.
	public class GameClass extends MovieClip
	{
		private var AppStage:Stage;
		private var MainPTR : MainClass;

		private var GameBackGround:GameBackGroundClass;
		private var Board:BoardClass;

		private var WhitePieces : Array = new Array();
		private var BlackPieces : Array = new Array();

		private var _AppFont = new AppFont();

		private var MenuButton : Button = new Button();
		private var ContinueButton : Button = new Button();
		
		private var TransparentBG : TransparentBGClass = new TransparentBGClass();
		private var WhiteWins : WhiteWinsClass = new WhiteWinsClass();
		private var BlackWins : BlackWinsClass = new BlackWinsClass();

		public function GameClass(AppStage : Stage, MainPTR : MainClass)
		{
			this.AppStage = AppStage;
			this.MainPTR = MainPTR;

			GameBackGround = new GameBackGroundClass();

			var Format : TextFormat = new TextFormat();
			Format.font = _AppFont;
			Format.size = 32;
			
			TransparentBG.width = AppStage.stageWidth;
			TransparentBG.height = AppStage.stageHeight;
			
			MenuButton.label = "Main Menu";
			MenuButton.setStyle("textFormat", Format);
			MenuButton.width = 256;
			MenuButton.height = 48;
			MenuButton.x = 16;
			MenuButton.y = 16;
			
			WhiteWins.x = AppStage.stageWidth / 2 - WhiteWins.width / 2;
			WhiteWins.y = AppStage.stageHeight / 3 - WhiteWins.height / 2;
			
			BlackWins.x = AppStage.stageWidth / 2 - BlackWins.width / 2;
			BlackWins.y = WhiteWins.y;
			
			ContinueButton.label = "Continue";
			ContinueButton.setStyle("textFormat", Format);
			ContinueButton.width = 256;
			ContinueButton.height = 48;
			ContinueButton.x = AppStage.stageWidth / 2 - ContinueButton.width/2;
			ContinueButton.y = WhiteWins.y + WhiteWins.height+32;
			
			Load();
		}
		
		private function Load() : void
		{
			Board = new BoardClass(AppStage, this);
			CreateWhitePieces();
			CreateBlackPieces();
			
			MenuButton.addEventListener(MouseEvent.CLICK, ReturnToMainMenu);
			ContinueButton.addEventListener(MouseEvent.CLICK, NewGame);
			AppStage.addChild(GameBackGround);
			AppStage.addChild(Board);
			AppStage.addChild(MenuButton);
		}
		
		public function ReturnToMainMenu(e : MouseEvent) : void
		{
			CleanUp();
			MainPTR.Load();
		}
		
		private function NewGame(e : MouseEvent) : void
		{
			if (AppStage.contains(WhiteWins))
				AppStage.removeChild(WhiteWins);
			if (AppStage.contains(BlackWins))
				AppStage.removeChild(BlackWins);
			AppStage.removeChild(TransparentBG);
			AppStage.removeChild(ContinueButton);
			
			CleanUp();
			Load();
		}
		
		public function DisplayWinner(WhiteToMoveNext : Boolean) : void
		{
			AppStage.addChild(TransparentBG);
			
			if (!WhiteToMoveNext)
				AppStage.addChild(WhiteWins);
			else
				AppStage.addChild(BlackWins);
			
			AppStage.addChild(ContinueButton);
		}

		private function CreateWhitePieces():void
		{
			var ecx:int = 0;
			for (ecx = 0; ecx < 8; ecx++)
			{
				ConstructPiece(new PawnClass(true), ecx, 6);
			}

			for (ecx = 0; ecx < 8; ecx+=7)
			{
				ConstructPiece(new RookClass(true), ecx, 7);
			}

			for (ecx = 1; ecx < 8; ecx+=5)
			{
				ConstructPiece(new KnightClass(true), ecx, 7);
			}

			for (ecx = 2; ecx < 8; ecx += 3)
			{
				ConstructPiece(new BishopClass(true), ecx, 7);
			}

			ConstructPiece(new QueenClass(true), 3, 7);
			ConstructPiece(new KingClass(true), 4, 7);

		}

		private function CreateBlackPieces():void
		{
			var ecx:int = 0;
			for (ecx = 0; ecx < 8; ecx++)
			{
				ConstructPiece(new PawnClass(false), ecx, 1);
			}

			for (ecx = 0; ecx < 8; ecx += 7)
			{
				ConstructPiece(new RookClass(false), ecx, 0);
			}

			for (ecx = 1; ecx < 8; ecx += 5)
			{
				ConstructPiece(new KnightClass(false), ecx, 0);
			}

			for (ecx = 2; ecx < 8; ecx += 3)
			{
				ConstructPiece(new BishopClass(false), ecx, 0);
			}

			ConstructPiece(new QueenClass(false), 3, 0);
			ConstructPiece(new KingClass(false), 4, 0);

		}

		private function ConstructPiece(NextPiece : PieceClass, CoordX : int, CoordY : int):void
		{
			NextPiece.x = Board.GetPosX(NextPiece.width,CoordX,CoordY);
			NextPiece.rotationX = 60;
			NextPiece.y = Board.GetPosY(CoordX,CoordY);
			Board.GameSquares[CoordY][CoordX].SetPiece(NextPiece);
		}

		private function CleanUp():void
		{
			//Reset statics
			GameStateClass.SetWhiteToMove(true);
			GameStateClass.SetWhiteCanCastle(true);
			GameStateClass.SetBlackCanCastle(true);
			GameStateClass.SetKingInCheck(false);
			GameStateClass.SetLastMoveWhiteLocationX(-1);
			GameStateClass.SetLastMoveWhiteLocationY(-1);
			GameStateClass.SetLastMoveBlackLocationX(-1);
			GameStateClass.SetLastMoveBlackLocationY(-1);
			GameStateClass.SetEnPassantX(-1);
			GameStateClass.SetEnPassantY(-1);
			MenuButton.removeEventListener(MouseEvent.CLICK, ReturnToMainMenu);
			ContinueButton.removeEventListener(MouseEvent.CLICK, NewGame);
			AppStage.removeChild(GameBackGround);
			AppStage.removeChild(Board);
			AppStage.removeChild(MenuButton);
		}

	}//End class Game

}//End package