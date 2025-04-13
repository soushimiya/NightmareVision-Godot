extends Node

# Custom Asset Getter for Modding
static func getBitmap(path:String) -> ImageTexture:
	var image = Image.new()
	image.load(path)
	return ImageTexture.create_from_image(image)

static func getSound(path:String) -> AudioStreamOggVorbis:
	return AudioStreamOggVorbis.load_from_file(path)

static func getText(path:String) -> String:
	var file = FileAccess.open(path, FileAccess.READ)
	return file.get_as_text()

static func getFont(path:String) -> FontFile:
	var font = FontFile.new()
	font.load_dynamic_font(path)
	return font
	
static func getSparrowAtlas(path:String) -> SpriteFrames:
	return null
	
static func exists(path) -> bool:
	return FileAccess.file_exists(path)
