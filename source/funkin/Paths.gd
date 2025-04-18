extends Node

const ignoreModFolders:Array = [
	'characters',
	'custom_events',
	'custom_notetypes',
	'data',
	'songs',
	'music',
	'sounds',
	'shaders',
	'noteskins',
	'videos',
	'images',
	'stages',
	'weeks',
	'fonts',
	'scripts',
	'achievements'
]

static var currentLibrary = "shared"
static func getPath(path:String, library:String = currentLibrary) -> String:
	var prefix = "assets/";
	if (OS.has_feature("standalone")):
		prefix = OS.get_executable_path() + "/" + prefix
	else:
		prefix = "res://" + prefix
	# lol
	if Assets.exists(modFolders(path)):
		return modFolders(path)
	if Assets.exists(prefix + currentLibrary + "/" + path):
		return prefix + currentLibrary + "/" + path
	
	return prefix + path

static var currentTrackedAssets = {}
static func image(path:String, folder:String = "images"):
	if currentTrackedAssets.has(path):
		return currentTrackedAssets.get(path)
	
	var asset = getPath(folder + "/" + path + ".png")
	if Assets.exists(asset):
		var bitmap = Assets.getBitmap(asset)
		currentTrackedAssets[path] = bitmap
		return bitmap
	
	print("oh no its returning null NOOOO (" + asset + ")")
	return null
	
static func txt(path:String, folder:String = "data") -> String:
	return getPath(folder + "/" + path + ".txt")

static func xml(path:String, folder:String = "data") -> String:
	return getPath(folder + "/" + path + ".xml")

static func json(path:String, folder:String = "data") -> String:
	return getPath(folder + "/" + path + ".json")

static func lua(path:String) -> String:
	return getPath(path + ".lua")

static func video(path:String, folder:String = "videos") -> String:
	return getPath(folder + "/" + path + ".mp4")
	
static func sound(path:String, folder:String = "sounds") -> String:
	return getPath(folder + "/" + path + ".ogg")
	
static func music(path:String, folder:String = "music") -> String:
	return getPath(folder + "/" + path + ".ogg")
	
static func font(path:String, folder:String = "music") -> String:
	return getPath(folder + "/" + path + ".ogg")

static func formatToSongPath(path:String) -> String:
	return path.to_lower().replace(' ', '-')

static func inst(song:String) -> String:
	return getPath("songs/" + formatToSongPath(song) + "/Inst.ogg")

static func voices(song:String, postfix:String = "") -> String:
	var voicePath = "Voices"
	if postfix != "":
		voicePath += "-" + postfix
	return getPath("songs/" + formatToSongPath(song) + "/" + voicePath + ".ogg")
	
static var currentModDirectory:String = ""

static func mods(path) -> String:
	return "content/" + path

static func modFolders(key) -> String:
	if (!currentModDirectory.is_empty()):
		var fileToCheck:String = mods(currentModDirectory + '/' + key)
		if (FileAccess.file_exists(fileToCheck)):
			return fileToCheck

	for mod in getModDirectories():
		var fileToCheck:String = mods(mod + '/' + key)
		if (FileAccess.file_exists(fileToCheck)):
			return fileToCheck
		
	return mods(key)

static func getModDirectories() -> Array:
	var list = []
	for folder in DirAccess.get_directories_at("content/"):
		if !ignoreModFolders.has(folder):
			list.push_back(folder)
	return DirAccess.get_directories_at("content/")
