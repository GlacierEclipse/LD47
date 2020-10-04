package sprites;

import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.FlxG;
import world.WorldManager;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;

class Turret extends GameSprite
{
	public var coolDown:Float;

	override public function new(x:Float, y:Float)
	{
		super(x, y);
		//loadGraphic("assets/images/turret.png", false);

		coolDown = 2.0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		coolDown -= elapsed;
		if (coolDown < 0)
			coolDown = 0;
		handleTurret();
	}

	public function handleTurret()
	{
        var playerPos:FlxVector = FlxVector.weak(WorldManager.getInstance().world.player.x, WorldManager.getInstance().world.player.y);
        playerPos.x = playerPos.x - (x + width / 2.0);
		playerPos.y = playerPos.y - (y + height / 2.0);
        playerPos.normalize();
        
        angle = angleLerp(angle , playerPos.degrees , 0.08) ;
		if (coolDown <= 0)
		{
			// We need to emit a new bullet here in the direciton of the mouse
			
			
            var shootDirP:FlxPoint = FlxPoint.weak(playerPos.x, playerPos.y);
            
            WorldManager.getInstance().world.enemyBullets.add(new BulletEnemy(x + getHalfWidth(), y + getHalfHeight(), shootDirP));

            coolDown = 2.0;
		}
    }
    
    function angleLerp(a0:Float,a1:Float,t:Float) 
    {
        var delta:Float = ((a1 - a0 + 360 + 180) % 360) - 180;
		return (a0 + delta * t + 360) % 360;
    }
}
