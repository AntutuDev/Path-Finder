﻿//used by PathFinder

package AStar {
	
	public class PathNode {
		public var x;
		public var y;
		public var g;
		public var h;
		public var parentNode:PathNode;
		
	//Constructor
		public function PathNode(xPos, yPos, gVal, hVal, link) {
			x = xPos;
			y = yPos;
			g = gVal;
			h = hVal;
			parentNode = link; 
		}
		
//end of class
	}
}
