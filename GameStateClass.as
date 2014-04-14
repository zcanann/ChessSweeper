package
{
	//Class for static variables that are annoying to keep track of elsewhere
    public class GameStateClass
	{
        public static var WhiteToMove : Boolean = true;
        public static var WhiteCanCastle : Boolean = true;
        public static var BlackCanCastle : Boolean = true;
        public static var KingInCheck : Boolean = false;
        public static var LastMoveWhiteLocationX : int = -1;
		public static var LastMoveWhiteLocationY : int = -1;
		public static var LastMoveBlackLocationX : int = -1;
		public static var LastMoveBlackLocationY : int = -1;
        public static var EnPassantX : int = -1;
		public static var EnPassantY : int = -1;

        public static function GameState() {}
		
		//
		// WHITE TO MOVE
		//
		public static function GetWhiteToMove() : Boolean
		{
			return WhiteToMove;
		}
		
		public static function SetWhiteToMove(_WhiteToMove : Boolean) : void
		{
			WhiteToMove = _WhiteToMove;
		}
		
		//
		// WHITE CAN CASTLE
		//
		public static function GetWhiteCanCastle() : Boolean
		{
			return WhiteCanCastle;
		}
		
		public static function SetWhiteCanCastle(_WhiteCanCastle : Boolean) : void
		{
			WhiteCanCastle = _WhiteCanCastle;
		}
		
		//
		// BLACK CAN CASTLE
		//
		public static function GetBlackCanCastle() : Boolean
		{
			return BlackCanCastle;
		}
		
		public static function SetBlackCanCastle(_BlackCanCastle : Boolean) : void
		{
			BlackCanCastle = _BlackCanCastle;
		}
		
		//
		// KING IN CHECK (can share variable since turn based)
		//
		public static function GetKingInCheck() : Boolean
		{
			return KingInCheck;
		}
		
		public static function SetKingInCheck(_KingInCheck : Boolean) : void
		{
			KingInCheck = _KingInCheck;
		}
		
		//
		// LAST LOCATION X WHITE
		//
		public static function GetLastMoveWhiteLocationX() : int
		{
			return LastMoveWhiteLocationX;
		}
		
		public static function SetLastMoveWhiteLocationX(_LastMoveWhiteLocationX : int) : void
		{
			LastMoveWhiteLocationX = _LastMoveWhiteLocationX;
		}
		
		//
		// LAST LOCATION Y WHITE
		//
		public static function GetLastMoveWhiteLocationY() : int
		{
			return LastMoveWhiteLocationY;
		}
		
		public static function SetLastMoveWhiteLocationY(_LastMoveWhiteLocationY : int) : void
		{
			LastMoveWhiteLocationY = _LastMoveWhiteLocationY;
		}
		
		//
		// LAST LOCATION X BLACK
		//
		public static function GetLastMoveBlackLocationX() : int
		{
			return LastMoveBlackLocationX;
		}
		
		public static function SetLastMoveBlackLocationX(_LastMoveBlackLocationX : int) : void
		{
			LastMoveBlackLocationX = _LastMoveBlackLocationX;
		}
		
		//
		// LAST LOCATION Y BLACK
		//
		public static function GetLastMoveBlackLocationY() : int
		{
			return LastMoveBlackLocationY;
		}
		
		public static function SetLastMoveBlackLocationY(_LastMoveBlackLocationY : int) : void
		{
			LastMoveBlackLocationY = _LastMoveBlackLocationY;
		}
		
		//
		// EN PASSANT X
		//
		public static function GetEnPassantX() : int
		{
			return EnPassantX;
		}
		
		public static function SetEnPassantX(_EnPassantX : int) : void
		{
			EnPassantX = _EnPassantX;
		}
		
		//
		// EN PASSANT Y
		//
		public static function GetEnPassantY() : int
		{
			return EnPassantY;
		}
		
		public static function SetEnPassantY(_EnPassantY : int) : void
		{
			EnPassantY = _EnPassantY;
		}
	}
}