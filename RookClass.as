package
{
    import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.events.*;
	
	//Class for a game piece
    public class RookClass extends PieceClass
	{
        public function RookClass(IsWhite : Boolean)
		{
			Frame = 4;
			super(IsWhite);
		}
		
		public override function CheckValidMove(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
		{
			return IsValidStraightMove(GameSquares, SourceSquare, TargetSquare);
		}
		
    } //End class GameTerrain

} //End package

