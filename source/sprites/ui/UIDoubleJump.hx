package sprites.ui;

import world.WorldManager;
import upgrades.GearManager;

class UIDoubleJump extends UIUpgradeAmount
{
	override public function new()
	{
		super();
		loadGraphic("assets/images/uiDoubleJump.png");
		width = 9;
		height = 6;
		offset.set(0, 0);
	}

	override function update(elapsed:Float)
	{
		x = WorldManager.getInstance().world.player.x + WorldManager.getInstance().world.player.width + 2;
		y = WorldManager.getInstance().world.player.y - 4;

		textAmount.text = Std.string(GearManager.getInstance().gear.doubleJump.currentValue);

		super.update(elapsed);
	}
}
