package sprites.ui;

import upgrades.GearManager;

class UIGearButtonDecrease extends UIGameButtonPlus
{
    override function update(elapsed:Float) 
    {
        super.update(elapsed);
    }
    override function canClick():Bool 
    {
        return upgradableRef.canDowngrade();
        
    }
}