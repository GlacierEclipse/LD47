package sprites.ui;

import upgrades.GearManager;
import world.WorldManager;

class UIRopeAmount extends UIUpgradeAmount
{
    override public function new() 
    {
        super();
        loadGraphic("assets/images/uiRope.png");
        width = 3;
        height = 9;
        offset.set(0,0);

    }

    override function update(elapsed:Float) 
    {
        x = WorldManager.getInstance().world.player.x - 16;
        y = WorldManager.getInstance().world.player.y;

        textAmount.text = Std.string(GearManager.getInstance().gear.ropeAmount.currentValue);
        
        super.update(elapsed);

    }
}