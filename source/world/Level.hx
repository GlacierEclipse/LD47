package world;

import flixel.tile.FlxTilemap;

class Level 
{
    public var tileMap:FlxTilemap;
    public static var levelWidthTiles:Int = 20;
    public static var levelHeightTiles:Int = 15;
    public static var levelTileSize:Int = 16;

    public function new() 
    {
        tileMap = new FlxTilemap();
    }
}