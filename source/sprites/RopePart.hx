package sprites;

class RopePart extends GameSprite
{
    public function new(x:Float, y:Float) 
    {
        super(x,y);
        loadGraphic("assets/images/rope.png");
        width = 7;
        offset.x = 3;
        height = 16;
    }

}