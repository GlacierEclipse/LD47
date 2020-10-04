package states;

import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import sprites.GameText;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import world.WorldManager;
import flixel.FlxState;


class CompleteGameState extends FlxState
{
	
	override public function create()
	{
        super.create();
        
        FlxG.camera.fade(FlxColor.BLACK, 1.0, true);
        FlxG.mouse.visible = false;

        var t1Text:GameText = new GameText(0,0, 0, "Congratulations, You have Broken the Loop!", 12);
        var t2Text:GameText = new GameText(0,0, 0,  "It took you: " + WorldManager.getInstance().restartsForWholeGame + " Loops", 12);
        var t3Text:GameText = new GameText(0,0, 0, "Thank you for playing :)", 12);
        var t4Text:GameText = new GameText(0,0, 0, "Press Space to return to the Main Menu", 12);

        t1Text.screenCenter(FlxAxes.X);
    

        
        t2Text.screenCenter(FlxAxes.X);
    

        
        t3Text.screenCenter(FlxAxes.X);
        t4Text.screenCenter(FlxAxes.X);
 
        add(t1Text);
        add(t2Text);
        add(t3Text);
        add(t4Text);

        FlxTween.tween(t1Text, {y: 30}, 3.0);
        FlxTween.tween(t2Text, {y: 60}, 4.0);
        FlxTween.tween(t3Text, {y: 90}, 5.0);
        FlxTween.tween(t4Text, {y: 110}, 5.0);

		
		FlxG.camera.color.setRGB(255,255,255,255);
	}

	override public function update(elapsed:Float)
	{
		
        if(FlxG.keys.anyJustPressed([SPACE,ENTER]))
        {
            FlxG.camera.shake(0.005, 1.0);
            
            FlxG.camera.flash(FlxColor.fromRGB(6,11,12));

            FlxG.camera.fade(FlxColor.BLACK, 1.0, false, switchToNewGame);
        }
		
		WorldManager.getInstance().update();
		super.update(elapsed);
    }
    
    public function switchToNewGame()
    {
        FlxG.switchState(new MenuState());
    }
}
