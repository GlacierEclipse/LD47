package sprites;

import flixel.text.FlxText;

class GameText extends FlxText
{
    override public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
    {
        super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
        scale.set(0.5, 0.5);
    }
}