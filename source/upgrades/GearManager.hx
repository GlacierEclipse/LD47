package upgrades;

class GearManager 
{
    public var availableGearPoints:Int;
    public var maxAvailableGearPoints:Int;
    
    public var gear:Gear;



    private static var instance:GearManager;

	private function new()
	{
		gear = new Gear();
		availableGearPoints = 0;
		maxAvailableGearPoints = 5;
		initToMax();
	}

	public function useGearPoints()
	{
		availableGearPoints--;
	}

	public function addGearPoints()
	{
		availableGearPoints++;
	}

	public function initToMax()
	{
		availableGearPoints = maxAvailableGearPoints;
	}

	public function canUsePoints() : Bool
		{
			return availableGearPoints > 0;
		}

	public static function getInstance():GearManager
	{
		if (instance == null)
			instance = new GearManager();
		return instance;
	}
}