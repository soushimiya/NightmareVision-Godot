extends AnimatedSprite2D
class_name Note

static var handler:NoteSkinHelper
const swagWidth:float = 160 * 0.7

var curAnim:String = ""
var animations:Dictionary = {}
var prevNote:Note
var nextNote:Note
var tail:Array = []
var playField

var noteDiff:float = 1000
var hitbox:float = Conductor.safeZoneOffset
var earlyHitMult:float = 0.5

var noteData:int = 0
var lane:int = 0
var strumTime:float = 0.0
var sustainLength:float = 0
var distance:float = 2000
var mustPress:bool = false
var isSustainNote:bool = false
var spawned:bool = false
var canBeHit:bool = false
var tooLate:bool = false
var wasGoodHit:bool = false
var ignoreNote:bool = false
var hitByOpponent:bool = false
var noteWasHit:bool = false

var baseScaleX:float = 1;
var baseScaleY:float = 1;
var offsetX:float = 0;
var offsetY:float = 0;

var hitsoundDisabled:bool = false

func _init(strumTime:float, noteData:int, prevNote:Note = null, sustainNote:bool = false, player:int = 0) -> void:
	if handler == null:
		handler = NoteSkinHelper.new(Paths.json("default", "noteskins"))
	
	self.strumTime = strumTime + ClientPrefs.noteOffset
	if (prevNote != null):
		self.prevNote = prevNote
		prevNote.nextNote = self
		
	isSustainNote = sustainNote
	self.noteData = noteData
	
	if ClientPrefs.middleScroll:
		position.x += PlayState.STRUM_X_MIDDLESCROLL + 50
	else:
		position.x += PlayState.STRUM_X + 50
	position.x += swagWidth * noteData
	
func _ready() -> void:
	sprite_frames = load(Paths.xml(handler.data.globalSkin, "images"))
	for anim in handler.data.noteAnimations[noteData]:
		self.animations.set(anim.anim, anim)
	scale = Vector2(0.7, 0.7)
		
	if !isSustainNote:
		var animToPlay:String = handler.data.noteAnimations[noteData][0].color + "Scroll"
		playAnim(animToPlay)
	
	# ToDo: fix offsets
	if isSustainNote:
		
		modulate = Color(255, 255, 255, 0.6)
		hitsoundDisabled = true
		offsetX += getTexture().get_width() / 2
		
		playAnim(handler.data.noteAnimations[noteData][0].color + "holdend")
		
		offsetX -= getTexture().get_width() / 2
		
		if prevNote.isSustainNote && prevNote != null:
			prevNote.playAnim(handler.data.noteAnimations[noteData][0].color + "hold")
			prevNote.scale.y *= Conductor.stepCrotchet / 100 * 1.05
			if (get_node_or_null("/root/Main/game/PlayState") != null):
				prevNote.scale.y *= get_node("/root/Main/game/PlayState").songSpeed
		else: if !isSustainNote:
			earlyHitMult = 1
	position.x += offsetX
	baseScaleX = scale.x
	baseScaleY = scale.y

func destroy():
	if (playField != null):
		playField.remNote(self)
	self.queue_free()
	
func _process(delta: float) -> void:
	var actualHitbox:float = hitbox * earlyHitMult
	var diff = (strumTime - Conductor.songPosition)
	noteDiff = diff
	var absDiff = abs(diff)
	canBeHit = absDiff <= actualHitbox
	if (hitByOpponent):
		wasGoodHit = true
	
	if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit):
		tooLate = true
	if (tooLate && modulate != Color(255, 255, 255, 0.3)):
		modulate = Color(255, 255, 255, 0.3)

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

func getTexture():
	return sprite_frames.get_frame_texture(animations.get(curAnim).name.trim_suffix("0"), 0)

func resizeByRatio(ratio:float): # haha funny twitter shit
	if (isSustainNote && curAnim.ends_with('end')):
		scale.y *= ratio
		baseScaleY = scale.y
