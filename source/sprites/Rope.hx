package sprites;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;
import world.WorldManager;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class Rope extends GameSprite
{
	public var ropePartLen:Int = 4;
	public var ropeShootSpeed:Float = 400;
	public var ropeInited:Bool;

	override public function new(x:Float, y:Float, ropePartsLen:Int, dirX:Float, dirY:Float)
	{
		super(x, y);



		loadGraphic("assets/images/rope.png");
		velocity.x = dirX * ropeShootSpeed;
		velocity.y = dirY * ropeShootSpeed;

        this.ropePartLen = ropePartsLen;
		

        ropeInited = false;
        
        width = 4;
        offset.x = 6;
        height = 10;
    }
    

	public function initRopeParts()
	{
		for (i in 0...ropePartLen)
		{
			var ropePart:RopePart = new RopePart(x, y);
            //ropePart.y += i * ropePart.height;
            FlxTween.tween(ropePart, {y : ropePart.y + i * 16}, 0.8, {ease: FlxEase.bounceOut});
			WorldManager.getInstance().world.ropeParts.add(ropePart);
		}
		ropeInited = true;
	}

	override function update(elapsed:Float)
	{
		

		var tempX:Float = x;
        var tempY:Float = y;
        
		x += velocity.x * FlxG.elapsed;
		y += velocity.y * FlxG.elapsed;

		if (WorldManager.getInstance().world.checkCollisionWithTiles(this) && !ropeInited)
		{
			if (velocity.x > 0)
			{
				x = (Std.int((x + width) / 16)) * 16 + 8 - getHalfWidth();
			}
			else if (velocity.x < 0)
			{
				x = (Std.int((x) / 16)) * 16 + 8;
			}

			if (velocity.y > 0)
			{
				y = (Std.int((y + height) / 16)) * 16 + height;
			}
			else if (velocity.y < 0)
			{
				y = (Std.int((y) / 16)) * 16 + height;
			}
            visible=false;
			velocity.x = 0;
			velocity.y = 0;

			initRopeParts();
		}
		else
		{
			x = tempX;
			y = tempY;
        }
        
        super.update(elapsed);
	}
}
