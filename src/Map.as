package 
{
	import flash.utils.Dictionary;
	import Math;
	/**
	 * ...
	 * @author Ailin Wuille Bille
	 */
	public class Map 
	{
		
		// generates the first level by default
		public function FirstMap():Array{
			var firstLevel:Array;
			firstLevel = [
				[1, 1, 1, 1, 0, 1, 1, 1],
				[0, 0, 0, 1, 0, 1, 0, 1],
				[1, 2, 2, 1, 0, 1, 0, 1],
				[1, 1, 1, 1, 0, 1, 0, 1],
				[1, 1, 0, 0, 0, 1, 0, 1],
				[1, 1, 1, 1, 0, 1, 0, 1],
				[1, 1, 1, 1, 1, 1, 0, 1]];
				
			return firstLevel;
		}
		
		//generates a new random map
		public function GenerateMap():Array{
			
			var level:Array;
			level = [
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0]];
			
			for (var row:int = 0; row < 7; row++ )
			{
				for (var col:int = 0; col < 8; col++ )
				{
					level[row][col] = Math.floor(Math.random() * 3);
				}
			}
			
			return level;
						
		}

	}

}