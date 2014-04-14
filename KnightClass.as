package
{
    import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.events.*;
	
	//Class for a game piece
    public class KnightClass extends PieceClass
	{
        public function KnightClass(IsWhite : Boolean)
		{
			Frame = 2;
			super(IsWhite);
		}
		
		public override function CheckValidMove(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
		{
			var DistanceH : int = Math.abs(SourceSquare.CoordX - TargetSquare.CoordX);
            var DistanceV : int = Math.abs(SourceSquare.CoordY - TargetSquare.CoordY);

            //Check for a movement of 2 in one direction and 1 in the other.
            if ((DistanceH == 1 && DistanceV == 2) || (DistanceH == 2 && DistanceV == 1))
                return true;

            //Not a valid knight move
            return false;
		}
		
    } //End class GameTerrain

} //End package

