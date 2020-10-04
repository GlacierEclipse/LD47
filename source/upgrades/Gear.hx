package upgrades;

class Gear 
{


    public var doubleJump:UpgradableValue;
    //public var dash:UpgradableValue;
    public var movementStamina:UpgradableValue;
    public var torchVisiblity:UpgradableValue;
    public var visionCone:UpgradableValue;
    public var ropeAmount:UpgradableValue;
    public var fallDamageBoots:UpgradableValue;
    
    
    public var climbingGearDurability:UpgradableValue;

    
    public var stickLightsAmount:UpgradableValue;

    public function new() 
    {
        doubleJump = new UpgradableValue(0.0, 0.0, 2.0, 1.0);
        //dash = new UpgradableValue(1, 0, 100, true);
        //movementStamina = new UpgradableValue(1, 0, 100, true);

        fallDamageBoots = new UpgradableValue(0.0, 0.0, 1.0, 1.0);
        ropeAmount = new UpgradableValue(0.0, 0.0, 5.0, 1.0);

        climbingGearDurability = new UpgradableValue(1.0, 1.0,4.0, 0.4);
        stickLightsAmount = new UpgradableValue(2.0, 2.0,5.0, 1.0);
    }

    public function initGear()
    {
        doubleJump.initToEmbark();
        fallDamageBoots.initToEmbark();
        ropeAmount.initToEmbark();
        climbingGearDurability.initToEmbark();
        stickLightsAmount.initToEmbark();
    }
}