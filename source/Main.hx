package;

import flixel.FlxGame;
import openfl.display.Sprite;
#if debug
#if hscript
import flixel.system.debug.console.ConsoleUtil;
#end
#end

class Main extends Sprite
{
	public function new()
	{
		super();

		ScriptManager.checkForUpdatedScripts();

		addChild(new FlxGame(0, 0, PlayState));

		#if debug
		#if hscript
		ConsoleUtil.registerFunction('checkForUpdatedScripts', () ->
		{
			ScriptManager.checkForUpdatedScripts();
		});
		#end
		#end
	}
}
