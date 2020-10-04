package world;

import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.math.FlxPoint;
import sprites.Player;
import sprites.TorchCone;
import sprites.Crosshair;
import sprites.BulletPlayer;
import sprites.BulletEnemy;
import sprites.Turret;
import sprites.Rope;
import sprites.RopePart;
import sprites.LightStick;
import sprites.Spikes;
import sprites.EndCube;

class World
{
	// The level contains everything in the world, all the levels, enemies, loot etc..
	public var levels:Array<Level>;
	public var player:Player;
	public var playerBullets:FlxTypedGroup<BulletPlayer>;
	public var enemyTurrets:FlxTypedGroup<Turret>;
	public var enemyBullets:FlxTypedGroup<BulletEnemy>;
	public var crosshair:Crosshair;
	public var ropes:FlxTypedGroup<Rope>;
	public var ropeParts:FlxTypedGroup<RopePart>;
	public var lightSticks:FlxTypedGroup<LightStick>;
	public var spikes:FlxTypedGroup<Spikes>;
	public var cube:EndCube;
	public var torchCone:TorchCone;

	public function new()
	{
		init();
	}

	public function init()
	{
		levels = new Array<Level>();
		levels.push(new Level());
		player = new Player(0, 0);
		playerBullets = new FlxTypedGroup<BulletPlayer>();
		enemyTurrets = new FlxTypedGroup<Turret>();
		enemyBullets = new FlxTypedGroup<BulletEnemy>();
		ropes = new FlxTypedGroup<Rope>();
		ropeParts = new FlxTypedGroup<RopePart>();
		lightSticks = new FlxTypedGroup<LightStick>();
		spikes = new FlxTypedGroup<Spikes>();
		torchCone = new TorchCone();
		cube = new EndCube(50, 50);

		crosshair = new Crosshair();
	}

	public var grid:Array<Array<Int>>;
	public var gridTemp:Array<Array<Int>>;

	public var gridW:Int = 64;
	public var gridH:Int = 64;

	public function generateGrid()
	{
		FlxG.camera.setScrollBounds(0, gridW * 16, 0, gridH * 16);
		FlxG.worldBounds.set(0, 0, gridW * 16, gridH * 16);
		// Pick a start position
		var startPosX:Int = 4;
		var startPosY:Int = 0;
		// Initial grid
		var randomChance:Float = 44.0;
		grid = new Array();
		gridTemp = new Array();
		for (x in 0...gridW)
		{
			grid[x] = new Array();
			gridTemp[x] = new Array();
			for (y in 0...gridH)
			{
				grid[x].push(FlxG.random.bool(randomChance) ? 1 : 0);
				gridTemp[x].push(grid[x][y]);
			}
		}

		var aliveCountLimit:Int = 4;
		var destroyCountLimit:Int = 4;

		var iteratorGrid:Int = 2;

		for (it in 0...iteratorGrid)
		{
			// Manipulate the temp grid

			// The actual algo goes here
			var xGr:Int = 0;
			var yGr:Int = 0;
			for (xGr in 0...gridW)
			{
				for (yGr in 0...gridH)
				{
					var countAlive:Int = countAliveCells(xGr, yGr);
					if (gridTemp[xGr][yGr] >= 1)
					{
						if (countAlive < destroyCountLimit)
						{
							gridTemp[xGr][yGr] = 0;
						}
					}
					else
					{
						if (countAlive > aliveCountLimit)
						{
							gridTemp[xGr][yGr] = FlxG.random.int(1, 3);
						}
					}
				}
			}

			// Copy the temp grid
			for (x1 in 0...gridW)
			{
				for (y1 in 0...gridH)
				{
					grid[x1][y1] = gridTemp[x1][y1];
				}
			}
		}

		/*
			var s:String = "";
			for (x in 0...gridW)
			{
				s = "";
				for (y in 0...gridH)
				{
					s += grid[x][y] + ",";
				}
				FlxG.log.add(s);
			}
		 */
	}

	public function placeEntities()
	{
		// Place the player -- find a good place
		var stopB:Bool = false;
		for (row in 1...5)
		{
			for (col in 1...gridW - 1)
			{
				if (grid[row][col] <= 0 && grid[row][col - 1] <= 0 && grid[row][col + 1] <= 0 && grid[row - 1][col] <= 0 && grid[row + 1][col] > 0)
				{
					player.setPosition(col * 16, row * 16);
					player.setSpawnPos(col * 16, row * 16);
					stopB = false;
					break;
				}
			}
			if (stopB)
				break;
		}





		// Place the end Cube
		var stopB:Bool = true;

		var cubePartPos:Int = 4;
		var regionXSearchStart:Int = FlxG.random.int(1, cubePartPos - 1);

		var cubeCol:Int = 0;
		var cubeRow:Int = 0;
		// regionXSearchStart = 4;
		for (rowwwww in 15...gridH - 1)
		{
			for (collll in 1...gridW - 1)
			{
				if (Std.int(collll / (gridW / cubePartPos)) == regionXSearchStart)
				{
					if (grid[rowwwww][collll] <= 0 && grid[rowwwww][collll - 1] <= 0 && grid[rowwwww][collll + 1] <= 0 && grid[rowwwww - 1][collll] <= 0
						&& grid[rowwwww + 1][collll] > 0)
					{
						cube.setPosition(collll * 16, rowwwww * 16);
						cube.setSpawnPos(collll * 16, rowwwww * 16);
						cubeCol = collll;
						cubeRow = rowwwww;
						stopB = false;
						break;
					}
				}
			}
			if (stopB)
				break;
		}

		if (stopB)
		{
			for (rowwwww in 15...gridH - 1)
			{
				for (collll in 1...gridW - 1)
				{
					if (grid[rowwwww][collll] <= 0 && grid[rowwwww][collll - 1] <= 0 && grid[rowwwww][collll + 1] <= 0 && grid[rowwwww - 1][collll] <= 0
						&& grid[rowwwww + 1][collll] > 0)
					{
						cube.setPosition(collll * 16, rowwwww * 16);
						cube.setSpawnPos(collll * 16, rowwwww * 16);
						stopB = false;
						cubeCol = collll;
						cubeRow = rowwwww;
						break;
					}
				}
				if (stopB)
					break;
			}
		}

		for (colClear in 0...gridH)
		{
			grid[cubeRow][colClear] = 0;
		}

		
		for (rowClear in 0...gridW)
			{
				grid[rowClear][cubeCol] = 0;
			}


		// Place the spikes
		var stopB:Bool = false;
		// var amountOfSpikes = WorldManager.getInstance().currentOverallLevelNum;
		var amountOfSpikes:Int = FlxG.random.int(WorldManager.getInstance().currentOverallLevelNum * 5,
			WorldManager.getInstance().currentOverallLevelNum * 10);
		amountOfSpikes = Std.int(FlxMath.bound(WorldManager.getInstance().currentOverallLevelNum * 10, 0, 150));

		for (rowSpike in 5...gridH - 1)
		{
			for (colSpike in 1...gridW - 1)
			{
				if (grid[rowSpike][colSpike] <= 0 && grid[rowSpike][colSpike - 1] <= 0 && grid[rowSpike][colSpike + 1] <= 0
					&& grid[rowSpike - 1][colSpike] <= 0 && grid[rowSpike + 1][colSpike] > 0)
				{
					addSpikeToWorld(colSpike * 16, rowSpike * 16 + 8);

					amountOfSpikes--;
					if (amountOfSpikes <= 0)
					{
						stopB = true;
						break;
					}
				}
			}
			if (stopB)
				break;
		}

		FlxG.log.add(cube.x);
		FlxG.log.add(cube.y);
	}

	public function countAliveCells(gridX:Int, gridY:Int):Int
	{
		var count:Int = 0;
		if (gridX - 1 < 0 || gridX + 1 >= gridW || gridY - 1 < 0 || gridY + 1 >= gridH)
			return 4;
		for (x in -1...2)
		{
			for (y in -1...2)
			{
				if (grid[gridX + x][gridY + y] > 0)
					count++;
			}
		}
		return count;
	}

	public function initWorldFromGrid()
	{
		var createdLevel:Level = new Level();

		createdLevel.tileMap.loadMapFrom2DArray(grid, AssetPaths.tiles__png, 16, 16, FlxTilemapAutoTiling.OFF, 1, 1);

		levels[0] = null;
		levels[0] = createdLevel;
	}

	public function addAreaToWorld(areaPosition:FlxPoint, areaNum:Int)
	{
		/*
			// Load the TiledMap tmx
			var tiledMap:TiledMap = new TiledMap("assets/data/area_" + areaNum + ".tmx");
			for (layer in tiledMap.layers)
			{
				var tiledLayer:TiledTileLayer = cast layer;
				var createdLevel:Level = new Level();
				createdLevel.tileMap.loadMapFromArray(tiledLayer.tileArray, tiledLayer.width, tiledLayer.height, AssetPaths.tiles__png, 16, 16,
					FlxTilemapAutoTiling.OFF, 1, 1);

				createdLevel.tileMap.setPosition(areaPosition.x, areaPosition.y);
				// Add the new level to the levels array
				levels.push(createdLevel);
			}
		 */
	}

	public function addTurretToWorld(turretX:Float, turretY:Float)
	{
		enemyTurrets.add(new Turret(turretX, turretY));
	}

	public function addSpikeToWorld(x:Float, y:Float)
	{
		spikes.add(new Spikes(x, y));
	}

	public function addEndCubeToWorld(x:Float, y:Float)
	{
		cube = new EndCube(x, y);
	}

	public function checkCollisionWithTiles(object:FlxBasic):Bool
	{
		for (level in levels)
		{
			if (level.tileMap.overlaps(object))
				return true;
		}
		return false;
	}

	public function checkCollisionWithRopes(object:FlxBasic):Bool
	{
		if (FlxG.overlap(ropeParts, object))
			return true;

		return false;
	}

	public function restartWorld()
	{
		// Restarting the world resets everything except the stick lights

		// Remove all the ropes


		ropeParts.clear();

		ropes.clear();



		FlxTween.tween(player, {x: player.spawnPosition.x, y: player.spawnPosition.y}, 1.0, {onComplete: onCompletePlayerLerp});
		player.active = false;

		player.initGameSprite();
	}

	public function clearWorld()
	{
		for (level in levels)
		{
			FlxG.state.remove(level.tileMap, true);
		}
		player.removeFromState();
		FlxG.state.remove(player, true);

		FlxG.state.remove(ropes, true);
		FlxG.state.remove(ropeParts, true);


		FlxG.state.remove(lightSticks, true);
		FlxG.state.remove(spikes, true);
		FlxG.state.remove(cube, true);



		FlxG.state.remove(playerBullets, true);
		FlxG.state.remove(enemyTurrets, true);
		FlxG.state.remove(enemyBullets, true);


		FlxG.state.remove(torchCone, true);

		FlxG.state.remove(crosshair, true);


		init();
	}

	public function onCompletePlayerLerp(_)
	{
		player.active = true;
		WorldManager.getInstance().restartingTweenRunning = false;
		WorldManager.getInstance().activateEmbarkScreen();
	}

	public function addWorldToState()
	{
		for (level in levels)
		{
			FlxG.state.add(level.tileMap);
		}
		FlxG.state.add(player);
		player.addToState();

		FlxG.state.add(ropes);
		FlxG.state.add(ropeParts);


		FlxG.state.add(lightSticks);
		FlxG.state.add(spikes);
		FlxG.state.add(cube);



		FlxG.state.add(playerBullets);
		FlxG.state.add(enemyTurrets);
		FlxG.state.add(enemyBullets);


		FlxG.state.add(torchCone);

		FlxG.state.add(crosshair);
	}
}
