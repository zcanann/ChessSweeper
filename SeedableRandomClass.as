package
{
	//Random class with support for seeds
	public class SeedableRandomClass
	{
		var MAX_RATIO:Number;
		var MIN_MAX_RATIO : Number;
		var Next:int;
		
		public function SeedableRandomClass() : void
		{
			MAX_RATIO = 1 / int.MAX_VALUE;
			MIN_MAX_RATIO = -MAX_RATIO;
			Next = 0;
		}
		
		public function RandomSeedableNumber(Seed:int, Start:Number, End:Number) : Number
		{
			Seed ^= (Seed << 21);
			Seed ^= (Seed >>> 35);
			Seed ^= (Seed << 4);
			
			Next = Seed;
			var Rand : Number;
			
			if (Seed < 0)
				Rand=Seed * MIN_MAX_RATIO;
			else
				Rand=Seed * MAX_RATIO;
		
			return Math.floor(Start + (Rand * (++End - Start)));
		}
		
		public function RandomSeedableInt(Seed : int, Start : Number = 0, End : Number = Number.MAX_VALUE) : int
		{
			return int(RandomSeedableNumber(Seed, Start, End));
		}
		
		public function RandomInt(Start : Number = 0, End : Number = Number.MAX_VALUE) : int
		{
			return int(RandomNumber(Start, End));
		}
		
		public function RandomNumber(Start : Number = 0, End : Number = Number.MAX_VALUE) : Number
		{
			return Math.floor(Start + (Math.random() * (++End - Start)));
		}
		
	} //End Class
	
} //End package