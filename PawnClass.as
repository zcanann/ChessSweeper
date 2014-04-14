package
{
    import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.events.*;
	
	//Class for a game piece
    public class PawnClass extends PieceClass
	{
		public var EnPassantAvailable : Boolean = false;
	
        public function PawnClass(IsWhite : Boolean)
		{
			Frame = 1;
			super(IsWhite);
		}
		
		public override function CheckValidMove(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
		{
			var DistanceH : int = SourceSquare.CoordX - TargetSquare.CoordX;
            var DistanceV : int = SourceSquare.CoordY - TargetSquare.CoordY;
			
			if (DistanceV == 0)
				return false;
			
            //Check for too great of a horizontal/vertical distance
            if (Math.abs(DistanceH) > 1 || Math.abs(DistanceV) > 2)
                return false;
			
            //Check for attempt to take diagonally and thrust at same time
            if (Math.abs(DistanceH) == 1 && Math.abs(DistanceV) == 2)
                return false;

            if (GameStateClass.GetWhiteToMove())
            {
                //Backwards movement check
                if (DistanceV < 0)
                    return false;
                //Check if moving forward by 2 and able to
                if (SourceSquare.CoordY != 6 && DistanceV == 2)
                    return false;
            }
            else
            {
                //Backwards movement check
                if (DistanceV > 0)
                    return false;
                //Check if moving forward by 2 and able to
                if (SourceSquare.CoordY != 1 && DistanceV == -2)
                    return false;
            }


            if (DistanceH == 0)
            {
				var ecx : int;
                //Check for pieces blocking vertically
                if (!GameStateClass.GetWhiteToMove())
				{
                    for (ecx = -1; ecx >= DistanceV; ecx--)
                    {
                        if (GameSquares[SourceSquare.CoordY - ecx][SourceSquare.CoordX].Piece != null)
                            return false;
                    }
				}
                else
                {
                    for (ecx = 1; ecx <= DistanceV; ecx++)
                    {
                        if (GameSquares[SourceSquare.CoordY - ecx][SourceSquare.CoordX].Piece != null)
                            return false;
                    }
                }

                //Mark possibility for an en passant after a thrust. Does not take into account if
                //the other player has pawns available to take the move
                if (Math.abs(DistanceV) == 2)
				{
                    GameStateClass.SetEnPassantX(TargetSquare.CoordX);
					GameStateClass.SetEnPassantY(TargetSquare.CoordY);
				}

                return true;
			}
			
			//Attempt to take another piece
            if (Math.abs(DistanceH) == 1)
            {
                if (GameSquares[TargetSquare.CoordY][TargetSquare.CoordX].Piece != null)
                    return true;
				var LastMoveLocationX : int;
				var LastMoveLocationY : int;
				
				if (GameStateClass.GetWhiteToMove())
				{
					LastMoveLocationX = GameStateClass.GetLastMoveBlackLocationX();
					LastMoveLocationY = GameStateClass.GetLastMoveBlackLocationY();
				}
				else
				{
					LastMoveLocationX = GameStateClass.GetLastMoveWhiteLocationX();
					LastMoveLocationY = GameStateClass.GetLastMoveWhiteLocationY();
				}
				
                //Check for en-passant
				if (GameStateClass.GetWhiteToMove())
				{
					if (LastMoveLocationX == GameStateClass.EnPassantX &&
						LastMoveLocationY == GameStateClass.EnPassantY &&
						GameStateClass.EnPassantY - 1 == TargetSquare.CoordY)
					{
             			//Manually kill en passant piece
						GameSquares[GameStateClass.EnPassantY][GameStateClass.EnPassantX].RemovePiece();
						return true;
                    }
				}
				else
				{
					if (LastMoveLocationX == GameStateClass.EnPassantX &&
						LastMoveLocationY == GameStateClass.EnPassantY &&
						GameStateClass.EnPassantY + 1 == TargetSquare.CoordY)
					{
						//Manually kill en passant piece
						GameSquares[GameStateClass.EnPassantY][GameStateClass.EnPassantX].RemovePiece();
						return true;
					}
				}


            }
			
			return false;
		}
		
    } //End class GameTerrain

} //End package

