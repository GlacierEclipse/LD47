package sprites.ui;

import world.WorldManager;
import flixel.util.FlxAxes;
import flixel.tweens.FlxTween;
import upgrades.GearManager;
import flixel.addons.ui.FlxButtonPlus;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.FlxBasic;

class UIGearBuyScreen extends GameSprite
{
	public var uiSprites:Array<UIGearBuy>;
	public var buyScreenText:GameText;
	public var embarkText:GameText;
	public var availablePoints:GameText;
	public var screenAlpha:Float;

	override public function new()
	{
		super(0, 0);
		visible = false;

		screenAlpha = 0.0;

		uiSprites = new Array<UIGearBuy>();

		
		
		buyScreenText = new GameText(0,0,0, "Prepare for the journey");
		
		buyScreenText.size = 14;
		buyScreenText.scrollFactor.set(0,0);
		buyScreenText.screenCenter(FlxAxes.X);
		buyScreenText.y = 9.0;

		
		availablePoints = new GameText(0,0,0, "Available Gear Points:");
		availablePoints.size = 16;
		availablePoints.scrollFactor.set(0,0);
		availablePoints.screenCenter(FlxAxes.X);

		availablePoints.x -= 25.0;
		availablePoints.y = 95.0;

		
		
		embarkText = new GameText(0,0,0, "Press SPACE To Embark");
		embarkText.size = 14;
		embarkText.scrollFactor.set(0,0);
		embarkText.screenCenter(FlxAxes.X);
		embarkText.y = 190.0;
        
        var startX:Float = 10;
		uiSprites.push(new UIGearBuy(startX, GearManager.getInstance().gear.ropeAmount, "assets/images/uiRope.png", "Ropes", -1.0));
		
		uiSprites.push(new UIGearBuy(startX + 80 * 1, GearManager.getInstance().gear.doubleJump, "assets/images/uiDoubleJump.png", "Double Jumps", -3.0 ));

		uiSprites.push(new UIGearBuy(startX + 80 * 2, GearManager.getInstance().gear.fallDamageBoots, "assets/images/uiBoots.png", "Fall Boots", -1.0));

		uiSprites.push(new UIGearBuy(startX + 80 * 3, GearManager.getInstance().gear.climbingGearDurability, "assets/images/uiGear.png", "Gear Durability", -4.0));
		
        //uiSprites[0].setSize(5,5);


    }
	
	
   

	override function addToState()
	{
		super.addToState();
		FlxG.state.add(buyScreenText);
		FlxG.state.add(embarkText);
		FlxG.state.add(availablePoints);
		for (sprite in uiSprites)
		{
            FlxG.state.add(sprite);
            sprite.addToState();
		}
	}

	override function removeFromState()
	{
		super.removeFromState();
		FlxG.state.remove(buyScreenText, true);
		FlxG.state.remove(embarkText, true);
		FlxG.state.remove(availablePoints, true);
		for (sprite in uiSprites)
		{
			FlxG.state.remove(sprite, true);
			sprite.removeFromState();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		buyScreenText.alpha = screenAlpha;
		availablePoints.alpha = screenAlpha;
		embarkText.alpha = screenAlpha;
		for (sprite in uiSprites)
			{
				sprite.alpha = screenAlpha;
				for (sprite1 in sprite.sprites)
					sprite1.alpha = screenAlpha;
			}


		if(WorldManager.getInstance().restartsForLevel > 0)
			{
			buyScreenText.text = "Loop " + WorldManager.getInstance().restartsForLevel;
			buyScreenText.screenCenter(FlxAxes.X);
			}
		availablePoints.text = "Available Gear Points: " + GearManager.getInstance().availableGearPoints;
		availablePoints.screenCenter(FlxAxes.X);
	}
}
