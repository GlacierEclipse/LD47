package sprites;

import world.WorldManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class FadeScreen extends FlxSprite
{
    override public function new() 
    {
        super(0,0);
        scrollFactor.set(0,0);
        makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true);
        alpha = 0.0;
        
    }

    public function startFadeIn(startAlpha:Float, endAlpha:Float)
    {
        
      
    }

    
    public function startFadeOut(startAlpha:Float, endAlpha:Float)
    {
        this.alpha = startAlpha;
        FlxTween.tween(this, {alpha : endAlpha}, 1.0);
        FlxTween.tween(WorldManager.getInstance().world.torchCone, {overallAlpha : 1.0}, 1.0);
      
    }

    override function update(elapsed:Float) 
    {
        
        super.update(elapsed);
    }

}