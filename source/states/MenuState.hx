package states;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import world.WorldManager;
import flixel.FlxState;


class MenuState extends FlxState
{
	
	override public function create()
	{
        super.create();
        
        FlxG.mouse.visible = false;

        add(new FlxSprite(0,0, "assets/images/Menu.png"));

		
		FlxG.camera.color.setRGB(255,255,255,255);
	}

	override public function update(elapsed:Float)
	{
		
        if(FlxG.keys.anyJustPressed([SPACE,ENTER]))
        {
            FlxG.camera.shake(0.01, 1.0);
            
            FlxG.camera.flash(FlxColor.fromRGB(6,11,12));

            FlxG.camera.fade(FlxColor.BLACK, 1.0, false, switchToNewGame);
        }
		
		WorldManager.getInstance().update();
		super.update(elapsed);
    }
    
    public function switchToNewGame()
    {
        FlxG.switchState(new PlayState());
    }
}
