package
{
    import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.events.*;
	
	//Class tha brings together several planes of terrain (edges and main terrain)
    public class BoardClass extends Sprite
	{
		private var ZoomFactor : Number = 128;
		private var AppStage : Stage;
		private var GamePTR : GameClass;
		
		private var ArbitraryXOffSetFixGarbage : int = 12;
		private var SquareSize = 64;
		
		public var VisualBoard = new GameVisualBoard();
		public var GameSquares : Array = new Array(8);
		
		private var WhitePieces : Array = new Array();
		private var BlackPieces : Array = new Array();
		
		private var SelectedSquare : SquareClass = null;
		
		private var SeedableRandom : SeedableRandomClass = new SeedableRandomClass();
		
		private var BoardBase : BoardBaseClass;
		
        function BoardClass(AppStage : Stage, GamePTR : GameClass)
		{
			this.AppStage = AppStage;
			this.GamePTR = GamePTR;
			
			CreateBoardSquares();
			PlaceMines(10);
			CountAdjacentSquares();

			//POSITION OBJECTS
			
			
			//Main terrain piece
			VisualBoard.x = AppStage.stageWidth / 2 - VisualBoard.width / 2 - ArbitraryXOffSetFixGarbage;
			VisualBoard.y = ZoomFactor;
			VisualBoard.z = AppStage.stageHeight / 2 - VisualBoard.height / 2;
			VisualBoard.rotationX = -45;
			
			BoardBase = new BoardBaseClass();
			//Arbitrary position setting. bad code practice only fit for a hackathon
			BoardBase.x = -4;
			BoardBase.y = 560;
			BoardBase.scaleX = 1.27;
			BoardBase.rotationX = 45;
			
			this.addChild(BoardBase);
			this.addChild(VisualBoard);
		}
		
		private function CountAdjacentSquares() : void
		{
			//Count adjacent shit for every square
			for (var CoordY : int = 0; CoordY < 8; CoordY++)
			{
				for (var CoordX : int = 0; CoordX < 8; CoordX++)
				{
					//Check those directly adjacent
					for (var AdjY : int = CoordY - 1; AdjY <= CoordY + 1; AdjY++)
					{
						for (var AdjX : int = CoordX - 1; AdjX <= CoordX + 1; AdjX++)
						{
							if (AdjX < 0 || AdjY < 0 ||
								AdjX > 7 || AdjY > 7)
								continue;
								
							if (AdjX == CoordX && AdjY == CoordY)
								continue;
							
							if (GameSquares[AdjY][AdjX].IsMine && !GameSquares[CoordY][CoordX].IsMine)
								GameSquares[CoordY][CoordX].AdjacentMines++;
						}
					}
					GameSquares[CoordY][CoordX].AddAdjacentObject();
				}
			}
		}
		
		private function PlaceMines(MineCount : int) : void
		{
			var SeedA : int = 666;
			var SeedB : int = 420;
			//Random mine coords
			while (MineCount > 0)
			{
				var MineX : int = Math.round(Math.random() * 7);
				var MineY : int = Math.round(Math.random() * 7);
				
				//var MineX : int = SeedableRandom.RandomSeedableInt(SeedA++,0,6);
				//var MineY : int = SeedableRandom.RandomSeedableInt(SeedB--,0,6);
				
				//Already place a mine here!
				if (GameSquares[MineY][MineX].IsMine)
					continue;
				
				MineCount--;
				GameSquares[MineY][MineX].IsMine = true;
				GameSquares[MineY][MineX].AdjacentMines = 0;
				
			}
		}
		
		private function CreateBoardSquares() : void
		{
			for (var CoordY : int = 0; CoordY < 8; CoordY++)
			{
				var VisualRow : Array = new Array(8);
				for (var CoordX : int = 0; CoordX < 8; CoordX++)
				{
					var NextSquareColor : MovieClip;
					var IsWhite : Boolean = false;
					
					//Set to white if applicable
					if (CoordX % 2 == CoordY % 2)
					{
						NextSquareColor = new GameWhiteSquareRaised();
						IsWhite = true;
					}
					else
						NextSquareColor = new GameBlackSquareRaised();
					
					NextSquareColor.x = CoordX * NextSquareColor.width;
					NextSquareColor.y = CoordY * NextSquareColor.height;
					
					var NextSquare : SquareClass = new SquareClass(AppStage);
					NextSquare.SetSquareObject(NextSquareColor, CoordX, CoordY, IsWhite);
					
					//Add each item to row individually
					VisualRow[CoordX] = NextSquare;
					
					VisualRow[CoordX].addEventListener(MouseEvent.CLICK, SquareClick);
					VisualRow[CoordX].mouseChildren = false;
					
					//Add to board
					VisualBoard.addChild(VisualRow[CoordX]);
				}
				//Add entire row to saved board
				GameSquares[CoordY] = VisualRow;
			}
		}
		
		private function BeginUncover(CoordX : int, CoordY : int) : void
		{
			//Bounds check
			if (CoordX < 0 || CoordY < 0 ||
				CoordX > 7 || CoordY > 7)
				return;
			
			//Check if already discovered or a mine
			if (GameSquares[CoordY][CoordX].Discovered ||
				GameSquares[CoordY][CoordX].IsMine)
				return;
				
			//Uncover this square
			
			GameSquares[CoordY][CoordX].Discover();
			
			//zeros are recursive and gay
			if (GameSquares[CoordY][CoordX].AdjacentMines == 0)
			{
				BeginUncover(CoordX + 1, CoordY);
				BeginUncover(CoordX - 1, CoordY);
				BeginUncover(CoordX, CoordY + 1);
				BeginUncover(CoordX, CoordY - 1);
			}
			
			
		}
		
		private function SquareClick(e : MouseEvent) : void
		{
			//Square being selected
			var TargetSquare : SquareClass = (SquareClass)(e.target);
			
			if (SelectedSquare == null)
			{
				//Initial selection cannot be empty
				if (TargetSquare.Piece == null)
					return;
				
				//Trying to select a black piece as white durrr
				if (TargetSquare.Piece.currentFrame > 6 && GameStateClass.WhiteToMove)
					return;
					
				//Trying to select a white piece as black durrr
				if (TargetSquare.Piece.currentFrame <= 6 && !GameStateClass.WhiteToMove)
					return;
				
				SelectedSquare = TargetSquare;
				SelectedSquare.Piece.alpha = 0.5;
			}
			else
			{
				//Check for taking of ones own pieces or piece doube click
				if (TargetSquare == SelectedSquare)
				{
					DeselectShit(TargetSquare);
					return;
				}
				if (TargetSquare.Piece != null)
				{
					if ((SelectedSquare.Piece.currentFrame <= 6 && TargetSquare.Piece.currentFrame <= 6)||
					(SelectedSquare.Piece.currentFrame > 6 && TargetSquare.Piece.currentFrame > 6))
					{
						DeselectShit(TargetSquare);
						return;
					}
				}
				
				//Check to see if move is valid
				var ValidMove : Boolean = SelectedSquare.Piece.CheckValidMove(
						GameSquares, SelectedSquare, TargetSquare);
				if (!ValidMove)
				{
					DeselectShit(TargetSquare);
					return;
				}
				
				//Remove piece from target
				TargetSquare.RemovePiece();
						
				//Move piece from source to destination
				TargetSquare.SetPiece(SelectedSquare.Piece);
				
				//Perform piece location calculations
				TargetSquare.Piece.x = GetPosX(TargetSquare.Piece.height,
											   TargetSquare.CoordX, TargetSquare.CoordY);
				TargetSquare.Piece.y = GetPosY(TargetSquare.CoordX, TargetSquare.CoordY);
				
				//Remove piece from source
				SelectedSquare.RemovePiece();
				
				//Test if moving to a mine and explode the piece
				if (GameSquares[TargetSquare.CoordY][TargetSquare.CoordX].IsMine &&
					!GameSquares[TargetSquare.CoordY][TargetSquare.CoordX].HasExploded)
					GameSquares[TargetSquare.CoordY][TargetSquare.CoordX].ExplodePiece();
						
				//Reveal shit on map
				BeginUncover(TargetSquare.CoordX, TargetSquare.CoordY);
				
				//Try to find king
				var KingPosition : Point = FindKing(GameStateClass.GetWhiteToMove());
				//King exploded!!! gg
				if (KingPosition.x == -1 || KingPosition.y == -1)
				{
					DeselectShit(TargetSquare);
					GamePTR.DisplayWinner(GameStateClass.GetWhiteToMove());
					return;
				}
				KingPosition = FindKing(!GameStateClass.GetWhiteToMove());
				//King exploded!!! gg
				if (KingPosition.x == -1 || KingPosition.y == -1)
				{
					DeselectShit(TargetSquare);
					GamePTR.DisplayWinner(!GameStateClass.GetWhiteToMove());
					return;
				}
				
				//Change turns and save old positions
				if (GameStateClass.GetWhiteToMove())
				{
					GameStateClass.SetLastMoveWhiteLocationX(TargetSquare.CoordX);
					GameStateClass.SetLastMoveWhiteLocationY(TargetSquare.CoordY);
				}
				else
				{
					GameStateClass.SetLastMoveBlackLocationX(TargetSquare.CoordX);
					GameStateClass.SetLastMoveBlackLocationY(TargetSquare.CoordY);
				}
				GameStateClass.SetWhiteToMove(!GameStateClass.GetWhiteToMove());
				
				//Clear check flag
				//GameStateClass.KingInCheck = false;
				//CheckForCheck(KingPosition.x, KingPosition.y);
				
				//Deselect shit
				DeselectShit(TargetSquare);
				
			} //End else
					
		} //End function SquareClick
		
		private function FindKing(WhiteKing : Boolean) : Point
		{
			//Ghetto index shit
			var IndexID : int = 6;
			if (!WhiteKing)
				IndexID = 12;
				
			for (var CoordY : int = 0; CoordY < 8; CoordY++)
			{
				for (var CoordX : int = 0; CoordX < 8; CoordX++)
				{
					if (GameSquares[CoordY][CoordX].Piece != null)
					{
						//Return coords if found
						if (GameSquares[CoordY][CoordX].Piece.currentFrame == IndexID)
							return new Point(CoordX, CoordY);
					}
					
				} //end for
				
			} //end for
			
			return new Point (-1, -1);
			
		} //end funct findking
		
		private function CheckForCheck(LocationX : int, LocationY : int) : Boolean
		{
			var IndexMin : int = 0;
			var IndexMax : int = 6;
			if (!GameStateClass.GetWhiteToMove())
			{
				IndexMin = 7;
				IndexMax = 12;
			}
			
			var Result : Boolean = false;
			
			for (var CoordY : int = 0; CoordY < 8; CoordY++)
			{
				for (var CoordX : int = 0; CoordX < 8; CoordX++)
				{
					if (GameSquares[CoordY][CoordX].Piece != null)
					{
						if (GameSquares[CoordY][CoordX].Piece.currentFrame >= IndexMin &&
							GameSquares[CoordY][CoordX].Piece.currentFrame <= IndexMax)
						{
							Result = GameSquares[CoordY][CoordX].Piece.IsCheckingPosition(GameSquares,
									GameSquares[CoordY][CoordX],GameSquares[LocationX][LocationY]);
							if (Result)
								return Result;
						}
					}
				} //end for
			} //end for
			
			return Result;
			
		} //end checkforcheck funct
		
		private function DeselectShit(TargetSquare) : void
		{
			//Restore alpha values & clear selection
			if (SelectedSquare.Piece != null)
				SelectedSquare.Piece.alpha = 1;
			if (TargetSquare.Piece != null)
				TargetSquare.Piece.alpha = 1;
			SelectedSquare = null;
		}
		
		public function GetPosX(PieceWidth : int, CoordX : int, CoordY : int) : int
		{
			var retVal : int = GameSquares[CoordY][CoordX].width / 2 - PieceWidth / 2;
			
			//Ghetto hackathon level garbage position fix
			if (CoordX <= 3)
				retVal -= PieceWidth/4;
			else if (CoordX >= 4)
				retVal += PieceWidth/4;
			
			return retVal;
		}
		
		public function GetPosY(CoordX : int, CoordY : int) : int
		{
			//Ghetto hackathon nonsense that would not fly in a real work environment
			var retVal : int =  0;
			//if (CoordY < 4)
				//retVal -= GameSquares[CoordY][CoordX].height / 2;
			return retVal;
		}
		
    } //End class GameTerrain

} //End package

