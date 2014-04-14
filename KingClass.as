package
{
    import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.events.*;
	
	//Class for a game piece
    public class KingClass extends PieceClass
	{
		public var CanCastle : Boolean = true;
		public var InCheck : Boolean = true;
		
        public function KingClass(IsWhite : Boolean)
		{
			Frame = 6;
			super(IsWhite);
		}
		
		public override function CheckValidMove(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
		{
			var DistanceH : int = (int)(Math.abs(SourceSquare.CoordX - TargetSquare.CoordX));
            var DistanceV : int = (int)(Math.abs(SourceSquare.CoordY - TargetSquare.CoordY));

            //Check for valid distances
            if (DistanceH <= 1 && DistanceV <= 1)
                return true;

            //Check for stupid castling method
            if (DistanceV == 0 && DistanceH == 2)
            {
                if (true /*White can castle and white to move no intermediate check*/)
                {
                    //TODO castling
                    return true;
                }

                if (true /*Black can castle and black to move no intermediate check*/)
                {
                    //TODO castling
                    return true;
                }
            }

            return false;
		}
		
    } //End class GameTerrain

} //End package

