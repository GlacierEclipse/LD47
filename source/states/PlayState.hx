package states;

import flixel.util.FlxColor;
import flixel.FlxG;
import world.WorldManager;
import flixel.FlxState;


class PlayState extends FlxState
{
	
	override public function create()
	{
		super.create();
		WorldManager.getInstance().startNewGame();
		FlxG.camera.fade(FlxColor.BLACK, 1.0, true, startNewGame);
		//WorldManager.getInstance().init();
		
		
		FlxG.camera.color.setRGB(255,255,255,255);
	}

	public function startNewGame()
	{
		
	}

	override public function update(elapsed:Float)
	{
		
		
		
		WorldManager.getInstance().update();
		super.update(elapsed);
	}
}
