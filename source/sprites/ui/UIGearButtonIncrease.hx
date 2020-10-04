package sprites.ui;

import upgrades.GearManager;

class UIGearButtonIncrease extends UIGameButtonPlus
{
    override function update(elapsed:Float) 
    {
        super.update(elapsed);
    }
    
    override function canClick():Bool 
    {
        return  upgradableRef.canUpgrade() && GearManager.getInstance().canUsePoints();
        
    }
}