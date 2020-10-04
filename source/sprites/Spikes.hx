package sprites;

import flixel.math.FlxMath;
import world.WorldManager;
import flixel.FlxG;

class Spikes extends GameSprite
{
    public var hitTimer:Float;
    override public function new(x:Float, y:Float) 
    {
        super(x, y);
        loadGraphic("assets/images/spike.png");
        height = 8;

        offset.y = 8;
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);
        hitTimer -= elapsed;
        hitTimer = FlxMath.bound(hitTimer, 0 , 5.0);
        if(WorldManager.getInstance().world.player.active && hitTimer <= 0.0)
            FlxG.overlap(this, WorldManager.getInstance().world.player, hitPlayer);
    }

    public function hitPlayer(d:Dynamic, d1:Dynamic)
    {
        hitTimer = 1.0;
        if(WorldManager.getInstance().world.player.velocity.y > 0 && !WorldManager.getInstance().world.player.onGround)
            WorldManager.getInstance().world.player.hit(1);
    }
}