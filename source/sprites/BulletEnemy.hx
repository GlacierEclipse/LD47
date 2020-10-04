package sprites;

import flixel.tweens.FlxTween;
import world.WorldManager;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class BulletEnemy extends GameSprite
{
    
    public var damage:Float = 1.0;
    public var bulletSpeed:Float = 700.0;

    override public function new(x:Float, y:Float, dir:FlxPoint) 
    {
        super(x,y);

        velocity.x = dir.x * bulletSpeed;
        velocity.y = dir.y * bulletSpeed;
        makeGraphic(5,5, FlxColor.RED);
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);
        if(WorldManager.getInstance().world.checkCollisionWithTiles(this))
            destroyBullet();
    }
    
    public function destroyBullet() 
    {
        velocity.x = 0;
        velocity.y = 0;
       deactivate();
    }

    override function deactivate() 
    {
        super.deactivate();
        FlxTween.tween(this, {"scale.x" : 0, "scale.y" : 0}, 0.5, 
            {onComplete: function onCom(_) {
                destroy();
                
            }}
        );
    }
}