package;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#else
import lime.utils.Assets;
#end

class Paths
{
	public static function getImagePath(path:String)
	{
		return 'assets/' + path + '.png';
	}

	public static function getTypeArray(type:String, type_folder:String, ext:Array<String>, paths:Array<String>,
			?foundFilesFunction:(Array<Dynamic>, String) -> Void = null):Array<String>
	{
		var arr:Array<String> = [];
		#if sys
		var arr_rawFileNames:Array<String> = [];
		var typePaths:Array<String> = paths;
		var typeExtensions:Array<String> = ext;

		var readFolder:Dynamic = function(folder:String, ogdir:String) {};

		var readFileFolder:Dynamic = function(folder:String, ogdir:String)
		{
			if (!FileSystem.isDirectory(ogdir + folder))
				return;

			for (file in FileSystem.readDirectory(ogdir + folder))
			{
				final endsplitter:String = !folder.endsWith('/') && !file.startsWith('/') ? '/' : '';
				for (extension in typeExtensions)
					if (file.endsWith(extension))
					{
						final path:String = ogdir + folder + endsplitter + file;

						#if typeArray_dupeFilePrevention
						if ((!arr_rawFileNames.contains(file)) && !arr.contains(path))
						{
							arr_rawFileNames.push(file);
							arr.push(path);
						}
						#else
						if (!arr.contains(path))
						{
							arr.push(path);
						}
						#end
					}

				if (!file.contains('.'))
					readFolder(file, ogdir + folder + endsplitter);
			}
		}

		readFolder = function(folder:String, ogdir:String)
		{
			if (!folder.contains('.'))
				readFileFolder(folder, ogdir);
			else
				readFileFolder(ogdir, '');
		}
		var readDir:Dynamic = function(directory:String)
		{
			if (pathExists(directory))
				for (folder in FileSystem.readDirectory(directory))
				{
					readFolder(folder, directory);
				}
		}

		for (path in typePaths)
		{
			readDir(path);
		}

		if (foundFilesFunction != null)
		{
			foundFilesFunction(arr, type);
		}
		else
		{
				trace('Found ' + arr.length + ' ' + type + ' files:');
				for (file in arr)
				{
					trace(' * ' + file);
				}
		}
		#end
		return arr;
	}

	public static function pathExists(id:String):Bool
	{
		#if sys
		return FileSystem.exists(id);
		#else
		return Assets.exists(id);
		#end
	}

	public static function getText(id:String):String
	{
		#if sys
		return File.getContent(id);
		#else
		return Assets.getText(id);
		#end
	}
}
