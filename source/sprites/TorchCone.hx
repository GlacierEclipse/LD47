package sprites;

import flixel.math.FlxVector;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import world.WorldManager;
import flixel.util.FlxColor;
import openfl.display.BlendMode;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;

class TorchCone extends FlxSprite
{
	public var torchLightMask:FlxSprite;

	public var radius:Float = 1.0;
	public var tempPoint:Point;

	public var flashlightVerts:Array<FlxPoint>;

	public var lightConeHeight:Float = 110.0;
	public var lightConeDistance:Float = 240.0;

	public var ambient = 0.94;

	public var overallAlpha = 1.0;

	override public function new()
	{
		super(0, 0);
		scrollFactor.set(0, 0);
		makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// pixels.fillRect(new Rectangle(0,0,FlxG.width, FlxG.height), 0xff000000);
		// torchLightMask = new FlxSprite(0,0);
		// torchLightMask.loadGraphic("assets/images/torchLightMask.png");
		// torchLightMask.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// torchLightMask.scale.set(1,1);
		// torchLightMask.scrollFactor.set(0,0);
		tempPoint = new Point();

		overallAlpha = 1.0;

		radius = 28.0;


		blend = BlendMode.MULTIPLY;

		flashlightVerts = new Array<FlxPoint>();
		flashlightVerts.push(new FlxPoint());
		flashlightVerts.push(new FlxPoint());
		flashlightVerts.push(new FlxPoint());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// scale.x = radius;
		// scale.y = radius;

		var pProject:FlxPoint = FlxPoint.weak();
		WorldManager.getInstance().world.player.getScreenPosition(pProject, null);
		// FlxG.log.add(pProject.x);
		// pProject.x *= radius;
		// pProject.y *= radius;
		// pProject.add(FlxG.camera.targetOffset.x, FlxG.camera.targetOffset.y);
		tempPoint.setTo(pProject.x, pProject.y);
		tempPoint.x += WorldManager.getInstance().world.player.width / 2.0;
		tempPoint.y += WorldManager.getInstance().world.player.height / 2.0;
		// tempPoint.setTo(50 , 0 );

		// tempPoint.x = 0;
		// tempPoint.y = 0;
		// tempPoint.setTo(tempPoint.x * radius, tempPoint.y * radius);

		// origin.x = tempPoint.x + torchLightMask.width / 2.0;
		// origin.y = tempPoint.y + torchLightMask.height / 2.0;
		// pixels.floodFill(0,0, 0xFF000000);

		var shootDirP:FlxPoint = FlxG.mouse.getScreenPosition();
		var shootDir:FlxVector = FlxVector.weak(shootDirP.x, shootDirP.y);

		shootDir.x = shootDir.x - (pProject.x + WorldManager.getInstance().world.player.width);
		shootDir.y = shootDir.y - (pProject.y + WorldManager.getInstance().world.player.height);
		shootDir.normalize();

		flashlightVerts[0].x = tempPoint.x;
		flashlightVerts[0].y = tempPoint.y;

		flashlightVerts[1].x = tempPoint.x + lightConeDistance;
		flashlightVerts[1].y = tempPoint.y - lightConeHeight;

		flashlightVerts[2].x = tempPoint.x + lightConeDistance;
		flashlightVerts[2].y = tempPoint.y + lightConeHeight;

		flashlightVerts[0].rotate(FlxPoint.weak(tempPoint.x, tempPoint.y), shootDir.degrees);
		flashlightVerts[1].rotate(FlxPoint.weak(tempPoint.x, tempPoint.y), shootDir.degrees);
		flashlightVerts[2].rotate(FlxPoint.weak(tempPoint.x, tempPoint.y), shootDir.degrees);

		// tempPoint.setTo(0,0);

		// torchLightMask.pixels.floodFill(0,0,0xFF000000);

		// antialiasing = true;

		// pixels.copyPixels(torchLightMask.pixels, new Rectangle(0, 0, torchLightMask.width, torchLightMask.height), tempPoint);
		// centerOrigin();



		// pixels.dr
	}

	override function draw()
	{
		FlxSpriteUtil.fill(this, FlxColor.fromRGBFloat(0, 0, 0, ambient));
		FlxSpriteUtil.drawCircle(this, tempPoint.x, tempPoint.y, radius, FlxColor.fromRGBFloat(1.0, 1.0, 1.0, 1.0 * overallAlpha));


		// Draw all the light sticks here
		for (lightStick in WorldManager.getInstance().world.lightSticks)
		{
			var pProject:FlxPoint = FlxPoint.weak();
			lightStick.getScreenPosition(pProject, null);


			FlxSpriteUtil.drawCircle(this, pProject.x + lightStick.getHalfWidth(), pProject.y + lightStick.getHalfHeight(), lightStick.radius,
				FlxColor.fromRGB(0, 255, 0, Std.int(100.0 * overallAlpha)));
		}

		// Draw the final cube here
		var pProjectC:FlxPoint = FlxPoint.weak();
		WorldManager.getInstance().world.cube.getScreenPosition(pProjectC, null);


		FlxSpriteUtil.drawCircle(this, pProjectC.x + WorldManager.getInstance().world.cube.width / 2.0, pProjectC.y + WorldManager.getInstance().world.cube.height / 2.0, WorldManager.getInstance().world.cube.width * WorldManager.getInstance().world.cube.scale.x,
			FlxColor.fromRGB(121, 192, 221, Std.int(100.0 )));


		FlxSpriteUtil.drawPolygon(this, flashlightVerts, FlxColor.fromRGBFloat(1.0, 1.0, 1.0, 0.7 * overallAlpha));
		super.draw();
	}
}
