package AStar {
	import flash.utils.Dictionary;
	import flash.geom.Point;
	
	public class PathFinder {
		private var finX;
		private var finY;
		private var level:Array;
		private var openList:Dictionary;
		private var closedList:Dictionary;
		public var path:Array;
		
	//returns an array of points in the path; if it's imposssible to find a path, return empty 
		public static function go(xIni, yIni, xFin, yFin, lvlData):Array {
				var finder:PathFinder = new PathFinder(xIni, yIni, xFin, yFin, lvlData);
				return finder.path.reverse();
			}
		
	//Constructor
		public function PathFinder(xIni, yIni, xFin, yFin, lvlData) {
			finX = xFin;
			finY = yFin;
			level = lvlData;
			openList = new Dictionary(true);
			closedList = new Dictionary(true);
			path = new Array();
			
			//first node is the starting point
			var node:PathNode = new PathNode(xIni, yIni, 0, 0, null); // starting node, no parent
			openList[xIni + " " + yIni] = node; // add the first node
			
			this.SearchLevel();
		}
		
	//the pathfinding algorithm
		private function SearchLevel():void {
			var curNode:PathNode;
			var lowF = 100000;
			var finished:Boolean = false;
			
			//first determine node with lowest F
			for each (var node in openList) {
				var curF = node.g + node.h;
				
				//currently this is just a brute force loop through every item in the list
				
				if (lowF > curF) {
					lowF = curF;
					curNode = node;
				}
			}
			
			//no path exists!
			if (curNode == null) {return;}
			
			//move selected node from open to closed list
			delete openList[curNode.x + " " + curNode.y];
			closedList[curNode.x + " " + curNode.y] = curNode;
			
			//check target
			if (curNode.x == finX && curNode.y == finY) {
				var endNode:PathNode = curNode;
				finished = true;
			}
			
			//check each of the 8 adjacent squares
			for (var i = -1; i < 2; i++) {
				for (var j = -1; j < 2; j++) {
					var col = curNode.x + i;
					var row = curNode.y + j;
					
						// if the candidate node is in a diagonal, don't add it to the openList
						if (!(VerifyDiagonals(curNode, col, row))){
							//make sure on the grid and not current node
							if ((col >= 0 && col < level[0].length) && (row >= 0 && row < level.length) && (i != 0 || j != 0)) {
									
									if (level[row][col] != 0 && closedList[col + " " + row] == null && openList[col + " " + row] == null) {
											//determine g
											var weight:int = level[row][col];
											var g = 10;
											if (level[row][col] == 2){ // if the tile priority is 2
																			
													g = 16; // made this number slightly bigger so the path avoids water 
												}
											g *= weight;							
											
											//calculate h
											var h = (Math.abs(col - finX)) + (Math.abs(row - finY)) * 10;							
											//create node
											var found:PathNode = new PathNode(col, row, g, h, curNode);
											openList[col + " " + row] = found;
										}
								}		
						}	
				}
				
			}
			
			//recurse if target not reached
			if (finished == false) {
				this.SearchLevel();
			} else {
				this.RetracePath(endNode);
			}
	}
	
	// checks if the candidate node is in any of the 4 diagonals
	private function VerifyDiagonals(curNode, col, row):Boolean {
		
		var b:Boolean = ((curNode.x - 1 == col && curNode.y - 1 == row) || (curNode.x + 1 == col && curNode.y - 1 == row) || (curNode.x - 1 == col && curNode.y + 1 == row) || (curNode.x + 1 == col && curNode.y + 1 == row)) ? true : false;	
			
		return b;

	}
		
	//construct an array of points by retracing searched nodes
		private function RetracePath(node):void {
			var step:Point = new Point(node.x, node.y);
			path.push(step);
			
			if (node.g > 0) {
				this.RetracePath(node.parentNode);
			}
		}
		
//end of class
	}
}
