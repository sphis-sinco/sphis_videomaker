package;

import events.CreateEvent;
import events.UpdateEvent;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	public static var video:String = 'unknown';
	public static var instance:PlayState = null;

	override public function new()
	{
		super();

		if (instance != null)
			instance = null;
		instance = this;
	}

	override public function create()
	{
		super.create();

		ScriptManager.call('onCreate', [new CreateEvent(video)]);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		ScriptManager.call('onUpdate', [new UpdateEvent(video, elapsed)]);

		
		if (FlxG.keys.justReleased.ESCAPE)
                        FlxG.switchState(() -> new VideoSelector());
	}
}
