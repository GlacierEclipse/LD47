package sprites;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class BulletPlayer extends GameSprite
{
    public var damage:Float = 1.0;
    public var bulletSpeed:Float = 700.0;

    override public function new(x:Float, y:Float, dir:FlxPoint) 
    {
        super(x,y);

        velocity.x = dir.x * bulletSpeed;
        velocity.y = dir.y * bulletSpeed;
        makeGraphic(5,5, FlxColor.ORANGE);
    }

}