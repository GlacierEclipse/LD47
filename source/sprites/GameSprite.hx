package sprites;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class GameSprite extends FlxSprite
{
	public var moveSpeed:Float;
	public var spawnPosition:FlxPoint;

	override public function new(x:Float, y:Float)
	{
		super(x, y);
		spawnPosition = new FlxPoint();
		initGameSprite();
	}

	public function addToState() {}

	public function removeFromState() {}

	public function setSpawnPos(x:Float, y:Float)
	{
		spawnPosition.set(x, y);
	}

	public function initGameSprite() {}

	public function hit(damage:Float)
	{
		health -= damage;
		if (health <= 0)
			deactivate();
	}

	public function blink(blinkTime:Float = 0.4, color:FlxColor = FlxColor.RED)
	{
		colorTransform.redOffset = color.red;
		colorTransform.greenOffset = color.green;
		colorTransform.blueOffset = color.blue;
		FlxTween.tween(this, {"colorTransform.redOffset": 0, "colorTransform.greenOffset": 0, "colorTransform.blueOffset": 0}, blinkTime);
	}

	public function deactivate()
	{
		alive = false;
		visible = true;
	}

	public function getGridPosInWorld(val:Int):Float
	{
		return Std.int(val / 16.0) * 16.0;
	}

	public function squish()
	{
		FlxTween.tween(this, {"scale.x": 0.8}, 0.05, {
			onComplete: function onCom(_)
			{
				FlxTween.tween(this, {"scale.x": 1.0}, 0.09);
			}
		});
	}

	public function squash()
	{
		FlxTween.tween(this, {"scale.y": 0.7}, 0.03, {
			onComplete: function onCom(_)
			{
				FlxTween.tween(this, {"scale.y": 1.0}, 0.09);
			}
		});
	}

	public function getHalfWidth():Float
	{
		return width / 2.0;
	}

	public function getHalfHeight():Float
	{
		return height / 2.0;
	}

	public function getCenterX():Float
	{
		return x + width / 2.0;
	}

	public function getCenterY():Float
	{
		return y + height / 2.0;
	}
}
