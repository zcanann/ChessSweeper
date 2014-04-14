package
{
    import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.events.*;
	
	//Class for a game piece
    public class BishopClass extends PieceClass
	{
        public function BishopClass(IsWhite : Boolean)
		{
			Frame = 3;
			super(IsWhite);
		}
		
		public override function CheckValidMove(GameSquares : Array, SourceSquare : SquareClass, TargetSquare : SquareClass) : Boolean
		{
			  return IsValidDiagonalMove(GameSquares, SourceSquare, TargetSquare);
		}
		
    } //End class GameTerrain

} //End package

