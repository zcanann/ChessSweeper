package
{
    import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.events.*;
	
	//Class for a game piece
    public class PieceClass extends GamePiece
	{
		protected var Frame : int;
		protected var IsWhite : Boolean = false;
		
        public function PieceClass(IsWhite : Boolean)
		{
			this.IsWhite = IsWhite;
			this.scaleX = 0.75;
			this.scaleY = 0.75;
			
			if (!IsWhite)
				Frame += 6;
			this.gotoAndStop(Frame);
		}
		
		//Check to see if the target is a valid move to go to
		public function CheckValidMove(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
		{
			//Overriden by extending classes
			//1) Check to see if in check already
			return true;
		}
		
		public function IsCheckingPosition(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) :  Boolean
		{
			return CheckValidMove(GameSquares, SourceSquare, TargetSquare);
		}
		
		//SHARED MOVEMENT FUNCTIONS
		
		protected function IsValidStraightMove(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) :  Boolean
		{
            var WorkingLocationX : int = SourceSquare.CoordX;
			var WorkingLocationY : int = SourceSquare.CoordY;

            //Determine horizontal and vertical directions
            var DirectionH : int = 0;
            var DirectionV : int = 0;
			 
            if (SourceSquare.CoordX > TargetSquare.CoordX)
                DirectionH = -1;
            else if (SourceSquare.CoordX < TargetSquare.CoordX)
                DirectionH = 1;

            if (SourceSquare.CoordY > TargetSquare.CoordY)
                DirectionV = -1;
            else if (SourceSquare.CoordY < TargetSquare.CoordY)
                DirectionV = 1;

            while (true)
            {
                //Ensure they occupy the same stretch
                if (SameStretch(SourceSquare, TargetSquare))
                {
                    //Move location to next diagonal
                    WorkingLocationX += 1 * DirectionH;
					WorkingLocationY += 1 * DirectionV;

                    //Don't check final square -- exit
                    if (WorkingLocationX == TargetSquare.CoordX && WorkingLocationY == TargetSquare.CoordY)
                        return true;

                    //Check for piece blocking the row/column
                    if (GameSquares[WorkingLocationY][WorkingLocationX].Piece != null)
                        return false;
                }
                else
                    return false; //Not the same stretch.
            }
			
			return false;
        }

        protected function IsValidDiagonalMove(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
        {
            var WorkingLocationX : int = SourceSquare.CoordX;
			var WorkingLocationY : int = SourceSquare.CoordY;
			
            //Determine horizontal and vertical directions
            var DirectionH : int = 1;
            var DirectionV : int = 1;
			
            if (SourceSquare.CoordX > TargetSquare.CoordX)
                DirectionH = -1;

            if (SourceSquare.CoordY > TargetSquare.CoordY)
                DirectionV = -1;

            while (true)
            {
                //Ensure they occupy the same diagonal
                if (SameDiagonal(SourceSquare, TargetSquare))
                {
                    //Move location to next diagonal
                    WorkingLocationX += 1 * DirectionH;
                    WorkingLocationY += 1 * DirectionV;

                    //Don't check final square -- exit
                    if (WorkingLocationX == TargetSquare.CoordX && WorkingLocationY == TargetSquare.CoordY)
                        return true;
						
					//Check for piece blocking the row/column
                    if (GameSquares[WorkingLocationY][WorkingLocationX].Piece != null)
                        return false;

                }
                else
                    return false; //Not the same diagonal.
            }
			
			return false;
        }

        protected function SameStretch(SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
        {
            //Get horizontal and vertical displacement distance
            var DistanceH : int = Math.abs(SourceSquare.CoordX - TargetSquare.CoordX);
            var DistanceV : int = Math.abs(SourceSquare.CoordY - TargetSquare.CoordY);

            //Check to see if the location is strictly horizontal or vertical
            if ((DistanceH == 0 && DistanceV != 0) || (DistanceH != 0 && DistanceV == 0))
                return true;

            return false;
        }

        protected function SameDiagonal(SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
        {
            if (Math.abs(SourceSquare.CoordX - TargetSquare.CoordX) == Math.abs(SourceSquare.CoordY - TargetSquare.CoordY))
                return true;

            return false;
        }
		
    } //End class GameTerrain

} //End package

