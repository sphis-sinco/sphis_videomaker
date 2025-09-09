package;

import events.CreateEvent;
import events.UpdateEvent;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import imports.FlxScriptedColor;

class VideoSelector extends FlxState
{
	public static var videos:Array<String> = [];

	public var videoText:FlxText;
	public var selection:Int = 0;

	override function create()
	{
		super.create();
		ScriptManager.call('onCreate', [new CreateEvent('VIDEOSCRIPTS_VIDEO_SELECTOR')]);

		videoText = new FlxText(10, 10, FlxG.width, 'video', 16);
		videoText.alignment = 'center';
		videoText.color = FlxScriptedColor.WHITE;
		add(videoText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		ScriptManager.call('onUpdate', [new UpdateEvent('VIDEOSCRIPTS_VIDEO_SELECTOR', elapsed)]);

		if (FlxG.keys.justReleased.LEFT)
			selection--;
		if (FlxG.keys.justReleased.RIGHT)
			selection++;

		if (selection < 0)
			selection = 0;
		if (selection >= videos.length)
			selection = videos.length - 1;

		videoText.text = '';

		if (selection - 1 < 0)
			videoText.text += '| ';
		else
			videoText.text += '< ';

		if (videos == [])
			videoText.text += 'No videos';
		else
			videoText.text += '"' + videos[selection] + '"';

		if (selection + 1 >= videos.length)
			videoText.text += ' |';
		else
			videoText.text += ' >';

		videoText.text += '\nPress enter to... enter this video';

		videoText.screenCenter();

		if (FlxG.keys.justReleased.ENTER)
		{
			PlayState.video = videos[selection];
			FlxG.switchState(() -> new PlayState());
		}
	}
}
