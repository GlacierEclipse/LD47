package sprites.ui;

import flixel.FlxG;

class UIUpgradeAmount extends GameSprite
{
    public var textAmount:GameText;
    
    public function new() 
    {
        super(0,0);
        textAmount = new GameText(0,0,0,"", 12);
        
        active = false;
    }

    override function update(elapsed:Float) 
    {
        textAmount.x = getCenterX() - textAmount.width / 2.0;
        textAmount.y = y + height - 4;

        super.update(elapsed);
    }
    override function addToState() 
    {
        super.addToState();
        FlxG.state.add(textAmount);
    }

    override function removeFromState()
    {
        FlxG.state.remove(textAmount,true);
    }
}