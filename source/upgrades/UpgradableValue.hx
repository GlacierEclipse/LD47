package upgrades;

import flixel.math.FlxMath;
import flixel.FlxG;

class UpgradableValue
{
	public var embarkMinVal:Float;
	public var embarkVal:Float;
	public var embarkMaxVal:Float;
	public var currentValue:Float;
	public var embarkRate:Float;

	public function new(embarkMinVal:Float, embarkVal:Float, embarkMaxVal:Float, embarkRate:Float)
	{
		this.embarkMinVal = embarkMinVal;
		this.embarkVal = embarkVal;
		this.embarkMaxVal = embarkMaxVal;
		this.currentValue = embarkVal;
		this.embarkRate = embarkRate;
	}

	public function initToEmbark()
	{
		currentValue = embarkVal;
	}

	public function upgrade()
	{
		if (canUpgrade())
		{
			embarkVal += embarkRate;
			initToEmbark();
			GearManager.getInstance().useGearPoints();
		}
	}

	public function downgrade()
	{
		if (canDowngrade())
		{
			embarkVal -= embarkRate;
			GearManager.getInstance().addGearPoints();
		}
		initToEmbark();
	}

	public function use(val:Float)
	{
		currentValue -= val;
		currentValue = FlxMath.bound(currentValue, 0.0, 10.0);
	}

	public function canUse():Bool
	{
		return currentValue > 0.0;
	}

	public function canUpgrade():Bool
	{
		return embarkVal < embarkMaxVal;
	}

	public function canDowngrade():Bool
	{
		return embarkVal > embarkMinVal;
	}

	public function tryUse(val:Float):Bool
	{
		if (canUse())
		{
			use(val);
			return true;
		}
		return false;
	}
}
