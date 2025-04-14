extends AnimatedSprite2D
class_name StrumNote

static var handler:NoteSkinHelper
var noteData:int = 0
var parent
var downScroll:bool = false

var curAnim:String = ""
var animations:Dictionary = {}
var resetAnim:float = 0

func _init(data, parent) -> void:
	self.noteData = data
	self.parent = parent
	# WIP also wtf is that noteskin system i don't fully understand how it works
	if handler == null:
		handler = NoteSkinHelper.new(Paths.json("default", "noteskins"))
	
func postAddedToGroup():
	position.x -= parent.swagWidth / 2
	position.x = position.x - (parent.swagWidth * 2) + (parent.swagWidth * noteData) + 54
	playAnim('static')

func _ready():
	sprite_frames = load(Paths.xml(handler.data.globalSkin, "images"))
	for anim in handler.data.receptorAnimations[noteData]:
		self.animations.set(anim.anim, anim)
		
func playAnim(name:String, force:bool = false) -> void:
	if !animations.has(name):
		return
	if force:
		stop()
	curAnim = name
	play(animations.get(name).xmlName, 24)
	# offsets sucks and i hate em
	offset = Vector2(animations.get(name).offsets[0]*-1, animations.get(name).offsets[1]*-1)

func _process(delta: float) -> void:
	if resetAnim > 0:
		resetAnim -= delta
		if (resetAnim <= 0):
			playAnim('static')
			resetAnim = 0
