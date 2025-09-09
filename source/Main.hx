package;

import flixel.FlxGame;
import flixel.system.debug.console.ConsoleUtil;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		ScriptManager.checkForUpdatedScripts();

		ConsoleUtil.registerFunction('checkForUpdatedScripts', () ->
		{
			ScriptManager.checkForUpdatedScripts();
		});

		addChild(new FlxGame(0, 0, PlayState));
	}
}
