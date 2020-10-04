package sprites.ui;

import upgrades.GearManager;
import world.WorldManager;

class UIBoots extends UIUpgradeAmount
{
    override public function new() 
    {
        super();
        loadGraphic("assets/images/uiBoots.png");
        width = 4;
        height = 5;
        offset.set(0,0);

    }

    override function update(elapsed:Float) 
    {
        x = WorldManager.getInstance().world.player.x + 7;
        y = WorldManager.getInstance().world.player.y + WorldManager.getInstance().world.player.height - 1;

        textAmount.text = Std.string(GearManager.getInstance().gear.fallDamageBoots.currentValue);
        
        super.update(elapsed);

    }
}