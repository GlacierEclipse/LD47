package sprites.ui;

import upgrades.GearManager;
import flixel.tweens.FlxTween;
import upgrades.UpgradableValue;
import flixel.FlxSprite;
import flixel.addons.ui.FlxButtonPlus;

class UIGameButtonPlus extends FlxButtonPlus
{
	public var spriteRef:FlxSprite = null;
	public var upgradableRef:UpgradableValue = null;

    
    
    /**
	 * This function is called when the button is clicked.
	 */
	override public function new(X:Float = 0, Y:Float = 0, ?Callback:UIGameButtonPlus->Void, ?Label:String, Width:Int = 100, Height:Int = 20)
	{
		super(X, Y, genericCallback, Label, Width, Height);
		this.onClickCallbackSprite = Callback;
	}

	public var onClickCallbackSprite:UIGameButtonPlus->Void;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (canClick())
			alpha = 1.0 * alpha; 
		if (!canClick())
			alpha = 0.5 * alpha;
		
	}

	public function canClick()
	{
		return true;
	}

	public function genericCallback()
	{
		if (canClick())
		{
			FlxTween.tween(this, {"scale.x": 0.7, "scale.y": 0.7}, 0.05, {
				onComplete: function name(_)
				{
					FlxTween.tween(this, {"scale.x": 1.0, "scale.y": 1.0}, 0.05);
				}
			});
			onClickCallbackSprite(this);
		}
	}
}
