package sprites;

import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import world.WorldManager;
import flixel.FlxG;

class EndCube extends GameSprite
{
    public var tweenCube:FlxTween;
    


    public var cubePick:FlxSound;
    override public function new(x:Float, y:Float) 
    {
        super(x, y);
        loadGraphic("assets/images/cube.png");
        scale.x = 2.0;
        scale.y = 2.0;
        tweenCube = FlxTween.tween(this, {"scale.x": 4.0, "scale.y": 4.0}, 0.9, {ease: FlxEase.bounceInOut, type:PINGPONG});

        cubePick = FlxG.sound.load("assets/sounds/CubePick.wav", 0.2);
    }

    override function update(elapsed:Float) 
    {
        if(WorldManager.getInstance().world.player.active)
        FlxG.overlap(WorldManager.getInstance().world.player, this, touchedPlayer);
        super.update(elapsed);

    }

    public function touchedPlayer(d:Dynamic, d1:Dynamic)
    {
        tweenCube.cancel();
        FlxTween.tween(this, {"scale.x": 0.0, "scale.y": 0.0}, 1.9, {});
        blink(0.4, FlxColor.WHITE);
        FlxG.camera.shake(0.005, 0.8);
        WorldManager.getInstance().playerTouchedEndCube();
        cubePick.play();
        active = false;
    }

}