package sprites;

import flixel.math.FlxMath;
import world.WorldManager;
import flixel.FlxG;

class Crosshair extends GameSprite
{
    override public function new() 
    {
        super(0,0);
        loadGraphic("assets/images/crosshair.png");
        visible = true;
    }
    override function update(elapsed:Float) 
    {
        super.update(elapsed);
        FlxG.mouse.visible = false;
        x = FlxG.mouse.x - getHalfWidth();
        y = FlxG.mouse.y - getHalfHeight();

        var deltaX:Float = x - WorldManager.getInstance().world.player.x;
        var deltaY:Float = y - WorldManager.getInstance().world.player.y;
        //FlxG.camera.followLead.set(500, 0.0);
        deltaX = FlxMath.remapToRange(deltaX, -FlxG.width / 2.0, FlxG.width / 2.0, -25, 25);
        deltaY = FlxMath.remapToRange(deltaY, -FlxG.height / 2.0, FlxG.height / 2.0, -25, 25);
        FlxG.camera.targetOffset.set(deltaX, deltaY);
        //FlxG.camera.of
        //FlxG.camera.updateFollow();
    }
}