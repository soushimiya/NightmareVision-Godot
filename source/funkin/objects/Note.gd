extends AnimatedSprite2D
class_name Note

static var handler:NoteSkinHelper
const swagWidth:float = 160 * 0.7

var curAnim:String = ""
var animations:Dictionary = {}
var noteData:int = 0
var isSustainNote:bool = false
var prevNote:Note
var nextNote:Note
var playField

func _init(strumTime:float, noteData:int, prevNote:Note = null, sustainNote:bool = false, player:int = 0) -> void:
	if handler == null:
		handler = NoteSkinHelper.new(Paths.json("default", "noteskins"))
	
	self.strumTime = strumTime
	if (prevNote != null):
		self.prevNote = prevNote
		prevNote.nextNote = self
	else:
		self.prevNote = self
	isSustainNote = sustainNote
	
func _ready() -> void:
	sprite_frames = load(Paths.xml(handler.data.globalSkin, "images"))
	for anim in handler.data.noteAnimations[noteData]:
		self.animations.set(anim.anim, anim)

func destroy():
	if (playField != null):
		playField.remNote(self)
	self.queue_free()

# offsets are fucking unused???? what the FUCK
func playAnim(name:String, force:bool = false) -> void:
	if !animations.has(name):
		return
	if force:
		stop()
	curAnim = name
	play(animations.get(name).xmlName, 24)
	# offsets sucks and i hate em
	offset = Vector2(animations.get(name).offsets[0]*-1, animations.get(name).offsets[1]*-1)
