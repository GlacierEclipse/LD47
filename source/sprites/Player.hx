package sprites;

import flixel.system.FlxSound;
import flixel.ui.FlxBar;
import sprites.ui.UIBoots;
import flixel.util.FlxColor;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.effects.particles.FlxEmitter;
import world.WorldManager;
import flixel.input.keyboard.FlxKeyboard;
import flixel.FlxG;
import upgrades.GearManager;
import sprites.ui.UIRopeAmount;
import sprites.ui.UIDoubleJump;
import sprites.ui.UIHpBar;

class Player extends GameSprite
{
	public var snowLandParticles:FlxEmitter;
	public var smokePlumesParticles:FlxEmitter;
	public var climbParticles:FlxEmitter;

	public var canDoubleJump:Bool;
	public var onGround:Bool;
	public var gravity:Float;

	public var jumpSpeed:Float;
	public var ropeClimbSpeed:Float;
	public var dashSpeed:Float;
	public var isDashing:Bool;

	public var fallDamageAmount:Float;

	public var lastFallY:Float;
	public var fallDistanceToDamage:Float;
	public var collidingWithRope:Bool;

	public var onRope:Bool;

	public var usingClimbingGear:Bool;
	public var onFall:Bool;
	public var climbRateDur:Float;

	// UI shit
	public var ropeAmountUI:UIRopeAmount;
	public var doubleJumpUI:UIDoubleJump;
	public var bootsUI:UIBoots;
	public var uiHPbar:UIHpBar;
	public var uiClimbBar:FlxBar;

	public var gearDurabilityCopy:Float;

	public var jumpSound:FlxSound;
	public var landSound:FlxSound;
	public var hurtSound:FlxSound;
	public var fireRopeSound:FlxSound;

	override public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic(AssetPaths.player__png, false);

		addEmitters();
		
		width = 7;
		height = 14;
		offset.y = 2;
		offset.x = 4;
		ropeAmountUI = new UIRopeAmount();
		doubleJumpUI = new UIDoubleJump();
		bootsUI = new UIBoots();
		uiHPbar = new UIHpBar();

		
		uiClimbBar = new FlxBar(0,0, FlxBarFillDirection.BOTTOM_TO_TOP, 4, 14, this, "gearDurabilityCopy", 0, 100, true);

		uiClimbBar.createColoredEmptyBar(FlxColor.fromRGB(79,107,127,150), true);
		uiClimbBar.createColoredFilledBar(FlxColor.fromRGB(158,214,255), true);
		uiClimbBar.trackParent(-7,0);


		hurtSound = FlxG.sound.load("assets/sounds/Hit_Hurt.wav", 0.2);
		jumpSound = FlxG.sound.load("assets/sounds/Jump28.wav", 0.2);
		landSound = FlxG.sound.load("assets/sounds/HitSnow.wav", 0.2);
		fireRopeSound = FlxG.sound.load("assets/sounds/Laser_Shoot22.wav", 0.2);
		
	}

	override function addToState()
	{
		FlxG.state.add(ropeAmountUI);
		ropeAmountUI.addToState();

		FlxG.state.add(doubleJumpUI);
		doubleJumpUI.addToState();
		
		FlxG.state.add(bootsUI);
		bootsUI.addToState();

		
		FlxG.state.add(uiHPbar);
		uiHPbar.addToState();

		FlxG.state.add(uiClimbBar);

		FlxG.state.add(snowLandParticles);
		FlxG.state.add(smokePlumesParticles);
		FlxG.state.add(climbParticles);

	}

	
	override function removeFromState() 
	{
		FlxG.state.remove(ropeAmountUI,true);
		ropeAmountUI.removeFromState();

		FlxG.state.remove(doubleJumpUI,true);
		doubleJumpUI.removeFromState();

		
		FlxG.state.remove(bootsUI,true);
		bootsUI.removeFromState();
		
		FlxG.state.remove(uiHPbar,true);
		uiHPbar.removeFromState();

		FlxG.state.remove(uiClimbBar,true);


		FlxG.state.remove(snowLandParticles,true);
		FlxG.state.remove(smokePlumesParticles,true);
		FlxG.state.remove(climbParticles,true);

	}

	public function addEmitters()
	{
		snowLandParticles = new FlxEmitter();
		snowLandParticles.loadParticles("assets/images/snowParticle.png", 50);
		// snowLandParticles.angle.set(0, 90);
		snowLandParticles.launchMode = FlxEmitterMode.SQUARE;
		// snowLandParticles.launchAngle.set(-70, -110);
		// snowLandParticles.speed.set(60);
		snowLandParticles.velocity.set(-9, -30, 9, -60);
		snowLandParticles.width = 8;
		snowLandParticles.acceleration.set(0, 100);
		snowLandParticles.scale.set(0.5, 0.5, 2, 2, 0, 0, 0, 0);
		snowLandParticles.lifespan.set(1, 1.5);


		smokePlumesParticles = new FlxEmitter();
		smokePlumesParticles.loadParticles("assets/images/basicParticle.png", 50);
		// snowLandParticles.angle.set(0, 90);
		smokePlumesParticles.launchMode = FlxEmitterMode.SQUARE;
		// snowLandParticles.launchAngle.set(-70, -110);
		// snowLandParticles.speed.set(60);
		smokePlumesParticles.velocity.set(-9, -9, 9, 9);
		smokePlumesParticles.width = 8;
		smokePlumesParticles.height = 8;
		smokePlumesParticles.scale.set(0.5, 0.5, 2, 2, 0, 0, 0, 0);
		smokePlumesParticles.lifespan.set(1, 1.5);

		

		climbParticles = new FlxEmitter();
		climbParticles.loadParticles("assets/images/basicParticle.png", 50);
		// snowLandParticles.angle.set(0, 90);
		climbParticles.launchMode = FlxEmitterMode.SQUARE;
		// snowLandParticles.launchAngle.set(-70, -110);
		// snowLandParticles.speed.set(60);
		climbParticles.velocity.set(-9, -9, 9, 9);
		climbParticles.width = 8;
		climbParticles.height = 8;
		climbParticles.scale.set(0.5, 0.5, 2, 2, 0, 0, 0, 0);
		climbParticles.lifespan.set(1, 1.5);
	}

	override function initGameSprite()
	{
		super.initGameSprite();

		GearManager.getInstance().gear.initGear();
		

		moveSpeed = 80.0;
		gravity = 5;
		velocity.x = 0;
		velocity.y = 0;
		jumpSpeed = 150.0;
		dashSpeed = 1000.0;
		ropeClimbSpeed = 60.0;
		canDoubleJump = false;
		onGround = true;
		fallDamageAmount = 0.5;
		climbRateDur = 0.005;

		health = UIHpBar.maxHP;

		usingClimbingGear = false;
		lastFallY = spawnPosition.y;

		// 4 block
		fallDistanceToDamage = 16 * 5.0;

		onRope = false;
	}

	override function update(elapsed:Float)
	{
		gearDurabilityCopy = FlxMath.remapToRange(GearManager.getInstance().gear.climbingGearDurability.currentValue, 0.0, GearManager.getInstance().gear.climbingGearDurability.embarkVal, 0, 100);
		if (!isDashing)
			velocity.x = 0;

		if(x + 50 < FlxG.worldBounds.x  || x - 50 > FlxG.worldBounds.right  || y - 10 > FlxG.worldBounds.bottom)
			hit(10.0);
			


		collidingWithRope = false;

		if (WorldManager.getInstance().world.checkCollisionWithRopes(this))
		{
			collidingWithRope = true;
		}
		else
		{
			onRope = false;
		}


		handleInput();
		handleGravity();

		if(velocity.y > 0)
		{
			if(!onFall)
			{
				lastFallY = y + height;
			}
			if(!onGround && !usingClimbingGear)
				onFall = true;
			else 
				onFall = false;
		}
		else 
			onFall = false;

		handleCollision();

		super.update(elapsed);

		
		ropeAmountUI.update(elapsed);
		doubleJumpUI.update(elapsed);
		bootsUI.update(elapsed);

		
		//uiClimbBar.setPosition(x,y);
	}

	public function handleInput()
	{
		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			if (!isDashing)
				velocity.x = moveSpeed;
		}

		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			if (!isDashing)
				velocity.x = -moveSpeed;
		}

		/*
			if (FlxG.keys.anyJustPressed([SPACE]))
			{
				handleDash();
			}
		 */

		// Rope takes priority
		if (collidingWithRope)
		{
			handleRopeLogic();
		}
		else
		{
			if (FlxG.keys.anyJustPressed([UP, W]) && !usingClimbingGear)
			{
				if (onGround)
				{
					velocity.y = -jumpSpeed;
					jumpSound.play();
					smokePlumesParticles.setPosition(getCenterX(), y + height - 5);
					smokePlumesParticles.start(true, 5, 5);

					squish();
				}
				else
				{
					
					handleDoubleJump();
				}
			}
		}

		if (FlxG.mouse.justPressed)
		{
			handleShootRope();
		}

		if (FlxG.keys.anyJustPressed([E]))
		{
			handleShootStickLight();
		}
	}

	public function handleGravity()
	{
		var gravityVal:Float = gravity;
		if (usingClimbingGear)
			velocity.y = 4;
		else
		{
			if (!onRope)
				velocity.y += gravityVal;
		}
	}

	public function handleCollision()
	{
		handleCollisionX();
		handleCollisionY();
	}

	public function handleCollisionX()
	{
		var tempX:Float = x;
		x += velocity.x * FlxG.elapsed;
		
		if (WorldManager.getInstance().world.checkCollisionWithTiles(this))
		{
			if (velocity.x > 0)
			{
				x = (Std.int((x + width) / 16)) * 16 - width;
				velocity.x = 0;


				if (!onRope && !onGround && velocity.y > 0 && GearManager.getInstance().gear.climbingGearDurability.tryUse(climbRateDur))
				{
					
					usingClimbingGear = true;
					climbParticles.setPosition(x, y);
					if(!climbParticles.emitting)
						climbParticles.start(false, 0.2, 5);
					// velocity.y = 0;
				}
				else
				{
					usingClimbingGear = false;
					climbParticles.emitting = false;
				}
			}
			else if (velocity.x < 0)
			{
				x = (Std.int((x) / 16)) * 16 + 15 + 1;
				velocity.x = 0;

				if (!onRope && !onGround && velocity.y > 0 && GearManager.getInstance().gear.climbingGearDurability.tryUse(climbRateDur))
				{
					climbParticles.setPosition(x, y);
					if(!climbParticles.emitting)
						climbParticles.start(false, 0.2, 5);
					
					usingClimbingGear = true;
					// velocity.y = 0;
				}
				else
				{
					usingClimbingGear = false;
					climbParticles.emitting = false;
				}
			}
		}
		else
		{
			x = tempX;
			usingClimbingGear = false;
		}
	}

	override function deactivate() 
	{
		super.deactivate();
		WorldManager.getInstance().restartWorld();
	}

	public function handleCollisionY()
	{
		var tempY:Float = y;
		y += velocity.y * FlxG.elapsed;
		if (WorldManager.getInstance().world.checkCollisionWithTiles(this))
		{
			if (velocity.y > 0)
			{
				y = (Std.int((y + height) / 16)) * 16 - height;
				if (!onGround)
				{
					snowLandParticles.setPosition(x + 4, y + height);
					snowLandParticles.start(true, 0, 4);
					handleFallDamage();
					squash();
					landSound.play();
				}
				canDoubleJump = true;
				velocity.y = 0;
				
				onGround = true;
				
			}
			else if (velocity.y < 0)
			{
				y = (Std.int((y) / 16)) * 16 + 15+1 ;
				velocity.y = 2;
			}
		}
		else
		{
			y = tempY;
			onGround = false;
			
			
		}
	}

	public function handleFallDamage()
	{
		var distanceFell:Float = Math.abs(lastFallY - (y+ height));
		//FlxG.log.add(y + height);
		//FlxG.log.add(lastFallY);
		//FlxG.log.add(distanceFell);
		if (distanceFell > fallDistanceToDamage)
		{
			if (GearManager.getInstance().gear.fallDamageBoots.tryUse(1.0))
			{
				blink(0.4, FlxColor.WHITE);
			}
			else
				hit(1.0);
		}
	}

	override function hit(damage:Float)
	{
		super.hit(damage);
		hurtSound.play();
		FlxG.camera.shake(0.0028, 0.22);
		blink();
	}

	public function tryUseMovement():Bool
	{
		if (GearManager.getInstance().gear.movementStamina.canUse())
		{
			GearManager.getInstance().gear.movementStamina.use(0.001);
			return true;
		}
		return false;
	}

	public function handleDoubleJump()
	{
		if (GearManager.getInstance().gear.doubleJump.canUse() && canDoubleJump)
		{
			jumpSound.play();
			GearManager.getInstance().gear.doubleJump.use(1);
			velocity.y = -jumpSpeed;
			canDoubleJump = false;
			smokePlumesParticles.setPosition(getCenterX(), y + height - 5);
			smokePlumesParticles.start(true, 5, 5);
		}
	}

	public function handleDash()
	{
		/*
			if (GearManager.getInstance().gear.dash.canUse())
			{
				GearManager.getInstance().gear.dash.use(1);
				if (FlxG.keys.anyPressed([RIGHT, D]))
					velocity.x = dashSpeed;
				else if (FlxG.keys.anyPressed([LEFT, A]))
					velocity.x = -dashSpeed;
				isDashing = true;
				FlxTween.tween(this, {"velocity.x": 0}, 0.2, {onComplete: onCompleteDash});
			}
		 */
	}

	public function handleShootRope()
	{
		if (GearManager.getInstance().gear.ropeAmount.tryUse(1))
		{
			fireRopeSound.play();
			var mousePos:FlxPoint = FlxG.mouse.getPosition();
			var shootDir:FlxVector = FlxVector.weak(mousePos.x, mousePos.y);
			shootDir.x = shootDir.x - (x + width / 2.0);
			shootDir.y = shootDir.y - (y + height / 2.0);
			shootDir.normalize();

			WorldManager.getInstance()
				.world.ropes.add(new Rope(x + getHalfWidth() + shootDir.x * 2.0, y + getHalfHeight() + shootDir.y * 2.0, 8, shootDir.x, shootDir.y));
			WorldManager.getInstance().world.crosshair.blink(0.4);
		}
	}

	public function handleShootStickLight()
	{
		if (GearManager.getInstance().gear.stickLightsAmount.tryUse(1))
		{
			var mousePos:FlxPoint = FlxG.mouse.getPosition();
			var shootDir:FlxVector = FlxVector.weak(mousePos.x, mousePos.y);
			shootDir.x = shootDir.x - (x + width / 2.0);
			shootDir.y = shootDir.y - (y + height / 2.0);
			shootDir.normalize();
			if (shootDir.x < 0)
			{
				shootDir.set(1, 0);
				shootDir.rotate(FlxPoint.weak(0, 0), -125);
			}
			else
			{
				shootDir.set(1, 0);
				shootDir.rotate(FlxPoint.weak(0, 0), -55);
			}
			WorldManager.getInstance()
				.world.lightSticks.add(new LightStick(getCenterX() + shootDir.x * 2.0, getCenterY() + shootDir.y * 2.0, shootDir.x, shootDir.y));
		}
	}

	public function handleRopeLogic()
	{
		if (!onRope)
		{
			if (FlxG.keys.anyPressed([UP, W]))
			{
				onRope = true;
			}
		}
		else
		{
			velocity.y = 0;
			if (FlxG.keys.anyPressed([UP, W]))
			{
				if (!onRope)
					onRope = true;
				velocity.y = -ropeClimbSpeed;
			}

			if (FlxG.keys.anyPressed([DOWN, S]))
			{
				velocity.y = ropeClimbSpeed;
			}
		}
	}

	public function onCompleteDash(_)
	{
		isDashing = false;
	}

	public function shootBullet() {}

	override function draw() 
	{
		//var prevX:Float = x;
		//var prevY:Float = y;
		//x = Math.round(x);
		//y = Math.round(y);
		super.draw();
		//x = prevX;
		//y = prevY;
	}
}
