package sprites.ui;

import world.WorldManager;
import flixel.FlxG;

class UIHpBar extends GameSprite
{
	public var hpSprites:Array<UIHp>;
	public static var maxHP:Int = 2;

	override public function new()
	{
		super(0, 0);
		visible = false;

		hpSprites = new Array<UIHp>();
		for (i in 0...maxHP)
		{
			hpSprites.push(new UIHp());
		}
	}

	override function addToState()
	{
		super.addToState();
		for (uiHP in hpSprites)
		{
			FlxG.state.add(uiHP);
		}
	}

	override function removeFromState()
	{
		super.removeFromState();
		for (uiHP in hpSprites)
		{
			FlxG.state.remove(uiHP, true);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        
		for (ind in 0...hpSprites.length)
		{
			hpSprites[ind].x = WorldManager.getInstance().world.player.x  + (ind * 7.0);
            hpSprites[ind].y = WorldManager.getInstance().world.player.y - 9.0;

            if(ind+1 > WorldManager.getInstance().world.player.health )
                hpSprites[ind].animation.frameIndex = 1;
            else 
                hpSprites[ind].animation.frameIndex = 0;
		}
	}
}
