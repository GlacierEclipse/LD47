package sprites;

import world.WorldManager;
import flixel.FlxG;
import flixel.math.FlxPoint;

class LightStick extends GameSprite
{
    public var radius:Float = 50.0;
	override public function new(x:Float, y:Float, dirX:Float, dirY:Float)
	{
		super(x, y);
		moveSpeed = 80.0;
		velocity.x = dirX * moveSpeed;
		velocity.y = dirY * moveSpeed;
		//acceleration.y = 70.0;
        loadGraphic("assets/images/lightstick.png");
        
        width = 3;
        height = 8;
        offset.x = 5+1;
	}

    override function update(elapsed:Float) 
    {
        velocity.y += 5.0;
        handleCollision();
        super.update(elapsed);
    }
    
	public function handleCollision()
	{
		handleCollisionX();
		handleCollisionY();
	}

	public function handleCollisionX()
	{
		var tempX:Float = x;
		x += velocity.x * FlxG.elapsed;
		if (WorldManager.getInstance().world.checkCollisionWithTiles(this))
		{
			if (velocity.x > 0)
			{
				x = (Std.int((x + width) / 16)) * 16 - width;
				velocity.x = 0;

			}
			else if (velocity.x < 0)
			{
				x = (Std.int((x) / 16)) * 16 + 15 + 1;
				velocity.x = 0;

			}
		}
		else
		{
			x = tempX;
		}
	}

	public function handleCollisionY()
	{
		var tempY:Float = y;
		y += velocity.y * FlxG.elapsed;
		if (WorldManager.getInstance().world.checkCollisionWithTiles(this))
		{
			if (velocity.y > 0)
			{
				y = (Std.int((y + height) / 16)) * 16 - height;
				//if (!onGround)
				{
					squash();
				}
                velocity.x = 0;
				velocity.y = 0;
			}
			else if (velocity.y < 0)
			{
				y = (Std.int((y) / 16)) * 16 + height;
				velocity.y = 2;
			}
		}
		else
		{
			y = tempY;
		}
	}
}
