extends Node

static var defaultLibrary:String = "shared/"

static func getPath(path:String, library:String = defaultLibrary) -> String:
	var prefix = "res://assets/";
	if (OS.has_feature("standalone")):
		prefix = OS.get_executable_path() + "/" + prefix
		
	return prefix + library + path

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
