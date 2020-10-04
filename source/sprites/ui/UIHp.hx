package sprites.ui;

class UIHp extends GameSprite
{
    override public function new() 
    {
        super(0,0);
        loadGraphic("assets/images/uiHp.png", true, 5,5);
        width = 5; 
        height = 5; 
        

    }
}