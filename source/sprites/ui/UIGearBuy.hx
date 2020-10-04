package sprites.ui;

import flixel.math.FlxMath;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import upgrades.UpgradableValue;
import upgrades.GearManager;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;

class UIGearBuy extends GameSprite
{
	public var gearImage:FlxSprite;
	public var buttonIncrease:UIGearButtonIncrease;
	public var amountText:GameText;
	public var plusText:GameText;
	public var minusText:GameText;
	public var gearText:GameText;
	public var buttonDecrease:UIGearButtonDecrease;



	public var sprites:FlxTypedGroup<FlxSprite>;


	public var upgradableValue:UpgradableValue;

	

	public function new(x:Float, upgradableVal:UpgradableValue, gearImageStr: String, gearTextStr:String, gearXOffset:Float)
	{
		super(0, 0);

		sprites = new FlxTypedGroup<FlxSprite>();

		this.upgradableValue = upgradableVal;
		visible = false;

        buttonIncrease = new UIGearButtonIncrease(0, 0, clickIncrease, "", 20, 20);
        amountText = new GameText(0,0,0, Std.string(upgradableVal.currentValue), 12);
        
        amountText.scrollFactor.set(0,0);
        buttonDecrease = new UIGearButtonDecrease(0, 0, clickDecrease, "", 20, 20);
        
        buttonIncrease.upgradableRef = upgradableVal;
        buttonDecrease.upgradableRef = upgradableVal;
        
        buttonIncrease.useScreenCoords = true;
		buttonDecrease.useScreenCoords = true;
		
		
        
        

        buttonDecrease.loadButtonGraphic(new FlxSprite(0, 0, "assets/images/uiButton.png"), new FlxSprite(0, 0, "assets/images/uiButtonHighlight.png"));
        
        buttonDecrease.scrollFactor.set(0,0);
         //buttonIncrease.scre
         buttonDecrease.x = x;
         buttonDecrease.y = 60;



        buttonIncrease.loadButtonGraphic(new FlxSprite(0, 0, "assets/images/uiButton.png"), new FlxSprite(0, 0, "assets/images/uiButtonHighlight.png"));
        
        buttonIncrease.scrollFactor.set(0,0);
        //buttonIncrease.scre
        buttonIncrease.x = x + 30;
        buttonIncrease.y = buttonDecrease.y;

        
        
       



        amountText.x = x + 17;
        amountText.y = buttonIncrease.y;


        plusText = new GameText(buttonIncrease.x + 3 ,buttonIncrease.y + 1,0, "+");
        plusText.scrollFactor.set(0,0);
        minusText = new GameText(buttonDecrease.x + 3 ,buttonDecrease.y + 1,0, "-");
		minusText.scrollFactor.set(0,0);
		

		this.gearImage = new FlxSprite(x + 22 + gearXOffset, buttonIncrease.y - 12, gearImageStr);
		this.gearImage.scrollFactor.set(0,0);

		
		
		this.gearText  = new GameText(gearImage.x  + 2,buttonIncrease.y - 30,0, gearTextStr, 12);
		this.gearText.x -= gearText.textField.width / 2.0;
		this.gearText.scrollFactor.set(0,0);
		


		sprites.add(gearImage);
		sprites.add(buttonIncrease);
		sprites.add(amountText);
		sprites.add(plusText);
		sprites.add(minusText);
		sprites.add(gearText);
		sprites.add(buttonDecrease);
		sprites.add(gearImage);
		sprites.add(gearText);

	}

	override function addToState()
	{
		super.addToState();
		FlxG.state.add(sprites);
	}

	override function removeFromState()
	{
		super.removeFromState();
		FlxG.state.remove(sprites,true);
	}

	public function clickIncrease(button:UIGameButtonPlus)
	{
		
		button.upgradableRef.upgrade();

		FlxG.log.add("clickyInc");
	}

	public function clickDecrease(button:UIGameButtonPlus)
	{
		//button.upgradableRef.maxValue++;
		button.upgradableRef.downgrade();

		FlxG.log.add("clickyDec");
    }
    
    override function update(elapsed:Float) 
    {

        super.update(elapsed);

		
		amountText.text = Std.string(FlxMath.roundDecimal(upgradableValue.embarkVal,1));
		if(Std.int(upgradableValue.embarkVal) != upgradableValue.embarkVal)
			amountText.x = buttonDecrease.x + 12.0;
    }

    override function draw() {
        super.draw();
    }
}
