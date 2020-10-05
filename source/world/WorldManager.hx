package world;

import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.display.BlendMode;
import flixel.text.FlxText;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.math.FlxPoint;
import sprites.FadeScreen;
import sprites.GameText;
import sprites.ui.UIGearBuyScreen;
import states.CompleteGameState;

class WorldManager
{
	public var world:World;

	public var fadeScreen:FadeScreen;
	public var levelCompleteText1:GameText;
	public var levelCompleteText2:GameText;

	public var gearBuyScreen:UIGearBuyScreen;

	public var currentOverallLevelNum:Int;
	public var maxLoopNum:Int = 10;

	public var waitingForNextLevelLoad:Bool = false;

	public var embarkScreenActive:Bool = false;

	public var restartsForLevel:Int = 0;
	public var restartsForWholeGame:Int = 0;

	public var restartingTweenRunning:Bool = false;

	public var tutorialMsgs:GameText;
	public var tutorialTween:FlxTween;

	public var playTutorial:Bool;

	public function init()
	{
		FlxG.camera.bgColor.setRGB(15, 26, 30);
		waitingForNextLevelLoad = false;
		FlxG.camera.follow(world.player, FlxCameraFollowStyle.LOCKON, 0.08);

		embarkScreenActive = false;

		// FlxG.camera.setScrollBounds(0,320,0,240);
	}

	public function startNewGame()
	{
		playTutorial = true;
		restartingTweenRunning = false;
		restartsForLevel = 0;
		restartsForWholeGame = 0;
		currentOverallLevelNum = 1;
		tutorialMsgs = new GameText(0, 0, 0, "Press E to shoot a light stick, you only have two! \n Press P to Regenerate the world!", 12);
		clearWorld();
		init();
		generateWorld(currentOverallLevelNum);
	}

	public function loadNextWorld()
	{
		currentOverallLevelNum++;
		clearWorld();
		init();
		generateWorld(currentOverallLevelNum);

		activateEmbarkScreen();
	}

	public function clearWorld()
	{
		fadeScreen = new FadeScreen();
		gearBuyScreen = new UIGearBuyScreen();
		levelCompleteText1 = new GameText(0, 0, 0, "", 32);
		levelCompleteText2 = new GameText(0, 0, 0, "Press Space to continue", 32);



		
		tutorialMsgs.scrollFactor.set(0, 0);
		tutorialMsgs.alpha = 0.0;




		// tutorialTween.can





		restartsForLevel = 0;
		levelCompleteText1.alpha = 0;
		levelCompleteText2.alpha = 0;

		FlxG.state.remove(tutorialMsgs, true);
		FlxG.state.remove(fadeScreen, true);
		FlxG.state.remove(levelCompleteText1, true);
		FlxG.state.remove(levelCompleteText2, true);
		gearBuyScreen.removeFromState();
		FlxG.state.remove(gearBuyScreen, true);





		world.clearWorld();
	}

	public function generateWorld(levelNum:Int)
	{
		currentOverallLevelNum = levelNum;
		// This is where we decide how to create the current level, We take the levelNum as an indication to the difficulty of the new world
		var amountOfEnemies:Int = 1;
		var amountOfLevelsToEnd:Int = 1;

		var currentDir:FlxPoint = new FlxPoint();

		world.generateGrid();
		var tryRegenLoop : Int = 4;
		
		var shouldRegen:Bool = !world.placeEntities();
		
		if(shouldRegen)
		{
			for (regenL in 0...tryRegenLoop)
			{
				world.generateGrid();
				shouldRegen = !world.placeEntities();
				if(!shouldRegen)
					break;
			}
		}

		world.initWorldFromGrid();
		// The currentLevel is going to be the generated stiched level


		// world.addTurretToWorld(40,40);

		world.addWorldToState();




		FlxG.state.add(tutorialMsgs);
		FlxG.state.add(fadeScreen);
		FlxG.state.add(levelCompleteText1);
		FlxG.state.add(levelCompleteText2);

		levelCompleteText1.alpha = 0;
		levelCompleteText2.alpha = 0;


		FlxG.state.add(gearBuyScreen);
		gearBuyScreen.addToState();
	}

	public function playerTouchedEndCube()
	{
		if (currentOverallLevelNum + 1 > maxLoopNum)
		{
			FlxG.camera.fade(FlxColor.BLACK, 1.0, false, function complete()
			{
				FlxG.switchState(new CompleteGameState());
			});

			// Fade the screen and load the next map in the fade
			levelCompleteText1.text = "Loop " + currentOverallLevelNum + " / " + maxLoopNum + " is broken ";
			FlxTween.tween(levelCompleteText1, {alpha: 1.0}, 0.8, {ease: FlxEase.bounceOut});
			FlxTween.tween(levelCompleteText2, {alpha: 1.0}, 1.4, {ease: FlxEase.bounceOut});
			levelCompleteText1.scrollFactor.set(0, 0);
			levelCompleteText2.scrollFactor.set(0, 0);
			levelCompleteText1.screenCenter();
			levelCompleteText2.screenCenter();
			world.player.active = false;

		}
		else
		{
			// Fade the screen and load the next map in the fade
			levelCompleteText1.text = "Loop " + currentOverallLevelNum + " / " + maxLoopNum + " is broken ";
			FlxTween.tween(levelCompleteText1, {alpha: 1.0}, 0.8, {ease: FlxEase.bounceOut});
			FlxTween.tween(levelCompleteText2, {alpha: 1.0}, 1.4, {ease: FlxEase.bounceOut});
			levelCompleteText1.scrollFactor.set(0, 0);
			levelCompleteText2.scrollFactor.set(0, 0);
			levelCompleteText1.screenCenter();
			levelCompleteText2.screenCenter();
			world.player.active = false;

			levelCompleteText2.y += 32.0;

			fadeScreen.alpha = 0.0;
			FlxTween.tween(fadeScreen, {alpha: 0.2}, 1.0, {
				onComplete: function name(_)
				{
					waitingForNextLevelLoad = true;
				}
			});
			FlxTween.tween(WorldManager.getInstance().world.torchCone, {ambient: 0.7}, 1.0);
			FlxTween.tween(WorldManager.getInstance().world.torchCone, {overallAlpha: 0.0}, 1.0);
		}
	}

	public function restartWorld()
	{
		if (!restartingTweenRunning)
		{
			restartsForLevel++;
			restartsForWholeGame++;
			world.restartWorld();
		}
		restartingTweenRunning = true;
	}

	public function activateEmbarkScreen()
	{
		embarkScreenActive = true;
		FlxTween.tween(gearBuyScreen, {"screenAlpha": 1.0}, 1.0);
		world.player.active = false;
		/*FlxTween.tween(fadeScreen, {alpha : 0.1}, 1.0, 
			{

			});
		 */





		FlxTween.tween(WorldManager.getInstance().world.torchCone, {overallAlpha: 0.0}, 1.0);
	}

	public function deActivateEmbarkScreen()
	{
		embarkScreenActive = false;
		FlxTween.tween(gearBuyScreen, {"screenAlpha": 0.0}, 1.0);
		world.player.active = true;
		FlxTween.tween(WorldManager.getInstance().world.torchCone, {overallAlpha: 1.0}, 1.0);
	}

	public function startTutorial()
	{
		var tutDur:Float = 3.0;
		tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 1.0}, 5.0, {
			onComplete: function tut2(_)
			{
				tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 0.0}, 5.0, {
					onComplete: function aaaaa(_)
					{
						tutorialMsgs.text = "Be careful of fall damage!";



						tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 1.0}, tutDur, {
							onComplete: function tut2End(_)
							{
								tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 0.0}, tutDur, {
									onComplete: function tut3Start(_)
									{
										tutorialMsgs.text = "Shoot a rope with mouse. \n Climb with W/S";





										tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 1.0}, tutDur, {
											onComplete: function tut3End(_)
											{
												tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 0.0}, tutDur, {
													onComplete: function tut4End(_)
													{
														tutorialMsgs.text = "Press A/D towards a wall to use climbing gear";





														tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 1.0}, tutDur, {
															onComplete: function tut5End(_)
															{
																tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 0.0}, tutDur, {
																	onComplete: function tut6(_)
																	{
																		tutorialMsgs.text = "Press R to restart.";
																		tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 1.0}, tutDur, {
																			onComplete: function tut7(_)
																			{
																				tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 0.0}, tutDur, {
																					onComplete: function tut8(_)
																					{
																						tutorialMsgs.text = "Objective: Find the LoopCube and destroy it.";
																						tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 1.0}, 4.0, {
																							onComplete: function tut9(_)
																							{
																								tutorialTween = FlxTween.tween(tutorialMsgs, {alpha: 0.0},
																									7.0);
																							}
																						});
																					}
																				});
																			}
																		});
																	}
																});
															}
														});
													}
												});
											}
										});
									}
								});
							}
						});
					}
				});
			}
		});
	}

	public function update()
	{
		if (world.player.active && playTutorial)
		{
			startTutorial();
			playTutorial = false;
		}

		if (FlxG.keys.anyJustPressed([R]) && !embarkScreenActive)
		{
			restartWorld();
		}

		if (waitingForNextLevelLoad && FlxG.keys.anyJustPressed([SPACE]))
		{
			waitingForNextLevelLoad = false;
			// fadeScreen.startFadeOut(0.8, 0.0);
			FlxTween.tween(levelCompleteText1, {alpha : 0.0}, 0.8);
			FlxTween.tween(levelCompleteText2, {alpha : 0.0}, 0.8);
			FlxG.camera.fade(FlxColor.BLACK, 1.0, false, onCompleteLevelTransition);
		}

		#if debug
			if (FlxG.keys.anyJustPressed([T]))
			{
				playerTouchedEndCube();
			}
		 #end

		if (FlxG.keys.anyJustPressed([P]))
		{
			// Fall back for shitty world gen

			clearWorld();
			init();
			generateWorld(currentOverallLevelNum);
		}

		if (embarkScreenActive && FlxG.keys.anyJustPressed([SPACE]))
		{
			deActivateEmbarkScreen();
		}
	}

	public function onCompleteLevelTransition()
	{
		loadNextWorld();
		FlxG.camera.fade(FlxColor.BLACK, 1.0, true);
	}

	private static var instance:WorldManager;

	private function new()
	{
		world = new World();
	}

	public static function getInstance():WorldManager
	{
		if (instance == null)
			instance = new WorldManager();
		return instance;
	}
}
