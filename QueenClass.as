package
{
    import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.events.*;
	
	//Class for a game piece
    public class QueenClass extends PieceClass
	{
        public function QueenClass(IsWhite : Boolean)
		{
			Frame = 5;
			super(IsWhite);
		}
		
		public override function CheckValidMove(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
		{
			//Check if diagonal is valid
            if (IsValidDiagonalMove(GameSquares, SourceSquare, TargetSquare))
                return true;

            //Check if stetch is valid
            if (IsValidStraightMove(GameSquares, SourceSquare, TargetSquare))
                return true;

            //Neither valid
            return false;
		}
		
    } //End class GameTerrain

} //End package

