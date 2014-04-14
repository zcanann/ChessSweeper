package
{
    import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.events.*;
	
	//Class for stuff
    public class SquareClass extends Sprite
	{
		private var AppStage : Stage;
		public var Piece : PieceClass = null;
		public var SquareObject : MovieClip;
		
		//Minesweeper related
		public var Discovered : Boolean = false;
		public var IsMine : Boolean = false;
		public var HasExploded : Boolean = false;
		public var AdjacentMines : int = 0;
		
		public var IsWhite : Boolean = false;
		
		public var CoordX : int;
		public var CoordY : int;
		
		private var AdjMineCounter : AdjacentMineCounter = new AdjacentMineCounter();
		
		
        public function SquareClass(AppStage : Stage) : void
		{
			this.AppStage = AppStage;
		}
		
		public function AddAdjacentObject() : void
		{
			AdjMineCounter.visible = false;
			SquareObject.addChild(AdjMineCounter);
		}
		
		public function Discover() : void
		{
			//Mark as a discovered square
			Discovered = true;
			
			//So lazy wut
			SquareObject.removeChildAt(0);
			
			if (IsWhite)
				SquareObject.addChildAt(new GameWhiteSquareLowered(), 0);
			else
				SquareObject.addChildAt(new GameBlackSquareLowered(), 0);
			
			//SquareObject.addChild(AdjMineCounter);
			//this.SetPiece(this.Piece);
			
			//Display counter if there is a number to show
			if (AdjacentMines == 0)
				return;
			AdjMineCounter.gotoAndStop(AdjacentMines);
			AdjMineCounter.visible = true;
		}
		
		//Explosion function triggered by standing on a mine
		public function ExplodePiece() : void
		{
			var PieceExplosion : PieceExplosionClass = new PieceExplosionClass();
			PieceExplosion.x = Piece.x + Piece.width / 2 - PieceExplosion.width / 2;
			PieceExplosion.y = Piece.y + Piece.height / 2 - PieceExplosion.height / 2;
			PieceExplosion.rotationX = 60;
			this.HasExploded = true;
			
			Discover();
			SquareObject.addChildAt(new MineExplodedClass(), 1);
			
			RemovePiece();
			SquareObject.addChild(PieceExplosion);
		}
		
		public function SetPiece(Piece : PieceClass) : void
		{
			if (Piece != null)
			{
				this.Piece = Piece;
				SquareObject.addChild(Piece);
			}
		}
		
		public function RemovePiece() : void
		{
			if (Piece != null)
				if (SquareObject.contains(Piece))
					SquareObject.removeChild(Piece);
			this.Piece = null;
		}
		
		public function SetSquareObject(SquareObject : MovieClip, CoordX : int, CoordY : int, IsWhite : Boolean) : void
		{
			this.CoordX = CoordX;
			this.CoordY = CoordY;
			this.IsWhite = IsWhite;
			this.SquareObject = SquareObject;
			this.addChild(SquareObject);
		}
		
    } //End class GameTerrain

} //End package

