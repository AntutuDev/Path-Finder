package
{
	import AStar.PathFinder;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	/**
	 * ...
	 * @author Ailin Wuille Bille
	 */
	public class Main extends Sprite
	{
		private var redoB:Sprite; // buttons
		private var ranB:Sprite;
		private var exitB:Sprite;
		private var style:TextFormat;
		private var color:ColorTransform;
		private var levelView:Dictionary;
		private var textBox:TextField;
		private var map:Map;
		private var clickCount:int = 0; // number of clicks
		private var xOri:int; // origin coordinates
		private var yOri:int;
		private var xDest:int; // destination coordinates
		private var yDest:int;
		private var stringO:String; //strings from dictionary
		private var stringD:String;
		private var level:Array; // numeric matrix
		private var result:Array; // path generated
		private var concatStr:String; // path coordinates string
		private var len:int; // result array's length
		
		
		public function Main()
		{
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}else
			{
				onInit();
			}
		} // end Main
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onInit():void
		{
			//START HERE!
			stage.color = 0x339999; // change bg color
			style = new TextFormat(); // text style
			concatStr = new String();
			style.bold = true;
			style.font = "Verdana";
			style.size = 20;
			style.align = "center";
			style.color = 0xFFFFFF;	
			
			textBox = new TextField(); // Text
			textBox.x = 60;
			textBox.y = 500;
			textBox.multiline = true;
			textBox.wordWrap = true;
			textBox.height = 100;
			textBox.width = 500;
			stage.addChild(textBox);
			textBox.defaultTextFormat = style;
			textBox.text = ("SELECT ORIGIN TILE");
			
			map = new Map();
			level= new Array();
			level = map.FirstMap(); // the first hardcoded level
			
			levelView = new Dictionary();
			levelView = AssignTiles(stage, level); // according to the generated priorities
			
			
			// DELETE button
			redoB = new TileGrass();
			redoB.x = 580;
			redoB.y = 100;
			stage.addChild(redoB);
			redoB.addEventListener(MouseEvent.CLICK, DeletePath);
			
			// RANDOM button
			ranB = new TileSand();
			ranB.x = 580;
			ranB.y = 200;
			stage.addChild(ranB);
			ranB.addEventListener(MouseEvent.CLICK, RandomMap);
			
			// EXIT button
			exitB = new TileRock();
			exitB.x = 580;
			exitB.y = 300;
			stage.addChild(exitB);
			exitB.addEventListener(MouseEvent.CLICK, QuitGame);
			
		} // end onInit
			
		// button event listeners
		// deletes the current path and resets the map
		private function DeletePath(e:MouseEvent):void{
			clickCount = 0;
			concatStr = " ";
			textBox.text = ("SELECT ORIGIN TILE");
			color.redMultiplier = 1.0;
			color.greenMultiplier = 1.0;
			for each(var node in result){ // clears the traced path
				var tile:Sprite = levelView[node.y + " " + node.x];
				tile.transform.colorTransform = color;
			} // end for each
			levelView[stringO].transform.colorTransform = color; //clears origin and destination nodes
			levelView[stringD].transform.colorTransform = color;
		}
		
		// generates a random map
		private function RandomMap(e:MouseEvent):void{
			clickCount = 0;
			concatStr = " ";
			textBox.text = ("SELECT ORIGIN TILE");
			level = map.GenerateMap();
			levelView = AssignTiles(stage, level);
			
		}
		// quits the .exe
		private function QuitGame(e:MouseEvent):void{
			
			fscommand("quit");
		}
		
		
		private function AssignTiles(stage, level):Dictionary{ // asigns the sprites to the tiles
			
			var levelView:Dictionary = new Dictionary();
			for (var row:int = 0; row < 7; row++ )
			{
				for (var col:int = 0; col < 8; col++ )
				{
					var tile:Sprite;
					var tileID:int = level[row][col];
					if (tileID == 0)
					{
						tile = new TileWall();
					}else if (tileID == 1)
					{
						tile = new TileWay();
					}else
					{
						tile = new TileWater();
					}
					
					tile.x = col * tile.width + 60; //offset
					tile.y = row * tile.height + 40;
					tile.name = row + " " + col;
					tile.addEventListener(MouseEvent.CLICK, onMouseClick);
					stage.addChild(tile);
					levelView[row + " " + col] = tile;
					
					}
				}
			return levelView;
		}
		
		private function DivideString(s1:String, s2:String):void{ // divides the dictionary key in 2
			xOri = parseInt(s1.substring(0, 1)); // saves the tile coordinates separatedly
			yOri = parseInt(s1.substring(2, 3));
			xDest = parseInt(s2.substring(0, 1));
			yDest = parseInt(s2.substring(2, 3));
		}
		
		private function onMouseClick(e:MouseEvent):void{ 
			color = e.currentTarget.transform.colorTransform;
			color.redMultiplier = 1.7; //colors origin and destination tiles
			clickCount++;
			if (clickCount == 1){ //first click is detected over a tile
				if (ValidateTile(e.currentTarget)){
					textBox.text = ("SELECT DESTINATION TILE");
					e.currentTarget.transform.colorTransform = color;
					stringO = e.currentTarget.name;
				}
				else{
					textBox.text = ("INVALID TILE, SELECT OTHER");
					clickCount--;
				}
			}
			else if(clickCount == 2){ // second click detected over a tile
			if (ValidateTile(e.currentTarget)){
					e.currentTarget.transform.colorTransform = color;
					stringD = e.currentTarget.name;
					
					// second valid tile triggers the pathfinder function
					DivideString(stringO, stringD);
					result = PathFinder.go(yOri, xOri, yDest, xDest, level);
					len = result.length;
					if(len > 0){
						for each(var node in result){
							var tile:Sprite = levelView[node.y + " " + node.x];
							var color:ColorTransform = tile.transform.colorTransform;
							color.greenMultiplier = 1.7;
							tile.transform.colorTransform = color;
						concatStr += " [" + tile.name + "]";
						} // end foreach
						textBox.text = ("PATH FOUND: " + concatStr); // shows the path
					} //end if
						else {
							textBox.text = ("UNABLE TO FIND PATH");
						}
					
					
				} 
				else{ // if tile is water or wall
					textBox.text = ("INVALID TILE, SELECT OTHER");
					clickCount--;
				}
			} // end else if click 2
		} // end onmouseclick
		
		private function ValidateTile(tile:Object):Boolean{ // verifies if the tile is walkable
			return (tile is TileWay) ? true : false;
		}

	}
	
}