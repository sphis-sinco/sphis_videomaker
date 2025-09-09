package ;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import events.AddedEvent;
import events.BaseEvent;
import events.BaseStateEvent;
import events.CreateEvent;
import events.UpdateEvent;
import imports.FlxScriptedAxes;
import imports.FlxScriptedColor;
import imports.FlxTextScriptedBorderStyle;
import lime.app.Application;

class ScriptManager
{
	public static var SCRIPT_FOLDER:String = 'scripts';

	public static var SCRIPT_EXTS:Array<String> = ['hx'];

	public static var SCRIPT_FOLDERS:Array<String> = [
		'assets/'
	];

	public static var SCRIPTS:Array<Iris> = [];
	public static var SCRIPTS_ERRS:Map<String, Dynamic> = [];

	public static function setVariableContains(needToContain:String, variable:Dynamic, newValue:Dynamic)
	{
		for (script in SCRIPTS)
		{
			if (StringTools.contains(script.name, needToContain))
			{
				if (script.exists(variable))
					script.set(variable, newValue);
			}
		}
	}

	public static function getVariableContains(needToContain:String, variable:Dynamic):Dynamic
	{
		for (script in SCRIPTS)
		{
			if (StringTools.contains(script.name, needToContain))
				if (script.exists(variable))
					return script.get(variable);
		}

		return null;
	}

	public static function setVariable(scriptPath:String, variable:Dynamic, newValue:Dynamic)
	{
		for (script in SCRIPTS)
		{
			if (script.name == scriptPath || script.name == scriptPath)
				if (script.exists(variable))
					script.set(variable, newValue);
		}
	}

	public static function getVariable(scriptPath:String, variable:Dynamic):Dynamic
	{
		for (script in SCRIPTS)
		{
			if (script.name == scriptPath || script.name == scriptPath)
				if (script.exists(variable))
					return script.get(variable);
		}

		return null;
	}

	public static function call(method:String, ?args:Array<Dynamic>)
	{
		if (method == null)
			return;
		if (SCRIPTS.length < 1)
			return;

		for (script in SCRIPTS)
		{
			callSingular(script, method, args);
		}
	}

	public static function callSingular(script:Iris, method:String, ?args:Array<Dynamic>)
	{
		if (method == null)
			return;

		if (!script.exists(method))
		{
			var errMsg = 'missing method('+method+') for script('+script.config.name+')';


			if (!SCRIPTS_ERRS.exists('missing_method(' + method + ')_' + script.config.name))
			{
				SCRIPTS_ERRS.set('missing_method(' + method + ')_' + script.config.name, errMsg);
					trace(errMsg);
			}

			return;
		}

		var ny:Dynamic = script.get(method);
		try
		{
			if (ny != null && Reflect.isFunction(ny))
			{
				script.call(method, args);
			}
		}
		catch (e)
		{
			var errMsg = 'error calling method('+method+') for script('+script.config.name+'): '+e.message;

			if (!SCRIPTS_ERRS.exists('method(' + method + ')_error_' + script.config.name))
			{
				SCRIPTS_ERRS.set('method(' + method + ')_error_' + script.config.name, errMsg);
				trace(errMsg);
			}
		}
	}

	public static function loadScriptByPath(path:String):Bool
	{
		var newScript:Iris;

		var noExt:Int = 0;
		for (ext in SCRIPT_EXTS)
		{
			if (!StringTools.endsWith(path, '.' + ext))
				noExt++;
		}
		if (noExt >= SCRIPT_EXTS.length)
			return false;

		try
		{
			newScript = new Iris(Paths.getText(path), new IrisConfig(path, true, true, []));
		}
		catch (e)
		{
			newScript = null;
				trace('Error loading script('
					+ e.message);
			Application.current.window.alert('Error loading script(' + path + '): ' + e.message + '\n\n' + e.details, 'Error loading script');
		}

		if (newScript != null)
		{
			initalizeScriptVariables(newScript);

				trace('Loaded script(' + path + ')');

			SCRIPTS.push(newScript);

			return true;
		}

		return false;
	}

	public static function initalizeScriptVariables(script:Iris)
	{
		script.set('VideoSelector', VideoSelector, false);
		script.set('PlayState', PlayState, false);

		script.set('AddedEvent', AddedEvent, false);
		script.set('CreateEvent', CreateEvent, false);
		script.set('UpdateEvent', UpdateEvent, false);
		script.set('BaseEvent', BaseEvent, false);
		script.set('BaseStateEvent', BaseStateEvent, false);

		script.set('Paths', Paths, false);
		script.set('ScriptManager', ScriptManager, false);

		scriptImports(script);
	}

	static function scriptImports(script:Iris)
	{
		script.set('FlxScriptedColor', FlxScriptedColor, false);
		script.set('FlxScriptedAxes', FlxScriptedAxes, false);
		script.set('FlxTextScriptedBorderStyle', FlxTextScriptedBorderStyle, false);
	}

	public static function loadScriptsByPaths(paths:Array<String>)
	{
		for (path in paths)
			loadScriptByPath(path);
	}

	public static function getAllScriptPaths(?foundFilesFunction:(Array<Dynamic>, String) -> Void = null):Array<String>
	{
		#if sys
		return Paths.getTypeArray('script', SCRIPT_FOLDER, SCRIPT_EXTS, SCRIPT_FOLDERS, foundFilesFunction);
		#else
		return [];
		#end
	}

	public static function checkForUpdatedScripts()
	{

		var scriptsString = [];
		var deletedScripts = [];
		var updatedScripts = [];
		for (script in SCRIPTS)
		{
			scriptsString.push(script.name);
			var path = script.name;

			@:privateAccess {
				if (!Paths.pathExists(script.name))
				{
					trace('script(' + script.name + ') has been removed');
					deletedScripts.push(script.name);
					script.destroy();
					SCRIPTS.remove(script);
				}
				else
				{
					if (Paths.getText(path) != script.scriptCode)
					{
						trace('script(' + script.name + ') had an update');
						updatedScripts.push(path);
						var scriptLayer:Int = 0;

						script.destroy();
						SCRIPTS.remove(script);

						var newScript = (loadScriptByPath(path)) ? SCRIPTS[SCRIPTS.length - 1] : null;

						if (newScript != null)
						{
							SCRIPTS.insert(scriptLayer, newScript);
							SCRIPTS.remove(SCRIPTS[SCRIPTS.length - 1]);
						}
					}
				}
			}
		}

		var ogFiles:Array<String> = getAllScriptPaths(function(arr, type) {});
		var needToAdd:Array<String> = [];

		var addition = '';
		var newCount = 0;

		getAllScriptPaths(function(arr, type)
		{
			for (script in deletedScripts)
				arr.push(script);

			for (file in ogFiles)
				if (!scriptsString.contains(file))
				{
					newCount++;
					needToAdd.push(file);
				}

			var newText = ((newCount > 0) ? (' (' + newCount + ' new)') : '');
				trace('Found ' + arr.length + ' ' + type + ' file(s)' + newText + ':');

			var i = 0;
			for (file in arr)
			{
				final ogFile = ogFiles[i];

				addition = '(loaded)';
				if (!scriptsString.contains(ogFile))
				{
					addition = '(new)';
					if (!scriptsString.contains(ogFile))
						scriptsString.push(ogFile);
				}

				if (deletedScripts.contains(ogFile) && deletedScripts.contains(file))
					addition = '(removed)';
				if ((updatedScripts.contains(ogFile) || updatedScripts.contains(file))
					|| (scriptsString.contains(ogFile) && !scriptsString.contains(file)))
				{
					if (!scriptsString.contains(file))
						scriptsString.push(file);
					addition = '(updated)';
				}

					trace(' * ' + file + ' ' + addition+'');

				i++;
			}

			loadScriptsByPaths(needToAdd);

			for (script in SCRIPTS.filter(f ->
			{
				return needToAdd.contains(f.name);
			}))
			{
				callSingular(script, 'onAdded', [new AddedEvent(script.name)]);
			}

			for (script in deletedScripts)
				arr.remove(script);
		});
	}
}