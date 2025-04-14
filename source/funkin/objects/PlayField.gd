extends Node2D
class_name PlayField

@export var ownerCharacter:String = "boyfriend"
@export var keyCount:int = 4:
	set(value):
		keyCount = value
		if (get_children().size() > 0):
			generateReceptors()
@export var autoPlayed:bool = false

signal noteHitCallback(note, playfield)
signal noteMissCallback(note, playfield)

var notes:Array = []
var offsetReceptors:bool = false
var baseAlpha:float = 1

const swagWidth:float = 160 * 0.7
	
func _ready() -> void:
	generateReceptors()
	
func clearReceptors():
	for note in get_children():
		remove_child(note)
		note.queue_free()

func generateReceptors():
	clearReceptors()
	for data in range(keyCount):
		var babyArrow = StrumNote.new(data, self)
		babyArrow.scale = Vector2(0.7, 0.7)
		babyArrow.downScroll = ClientPrefs.downScroll
		add_child(babyArrow)
		babyArrow.postAddedToGroup()
	fadeIn(false)

func fadeIn(skip:bool = false):
	for data in range(get_children().size()):
		var babyArrow = get_children()[data]
		if skip:
			babyArrow.modulate = Color.WHITE
		else:
			var daY = 10
			if babyArrow.downScroll:
				daY *= -1
			babyArrow.global_position.y -= daY
			babyArrow.modulate = Color.TRANSPARENT
			get_tree().create_timer(0.5 + 0.2*data).timeout.connect(func():
				var tween = create_tween().set_parallel()
				tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
				tween.tween_property(babyArrow, "modulate", Color.WHITE, 1)
				tween.tween_property(babyArrow, "global_position:y", babyArrow.global_position.y + daY, 1)
			)

func getNotes(dir):
	var collected = []
	for note in notes:
		if (note.alive && note.noteData == dir && !note.wasGoodHit && !note.tooLate && note.canBeHit):
			collected.push(note)
	return collected

# fuck gdscript
func getTapNotes(dir):
	return getNotes(dir).filter(func(note): return !note.isSustainNote)
func getHoldNotes(dir):
	return getNotes(dir).filter(func(note): return note.isSustainNote)

func removeNote(note):
	notes.erase(note)
	if note.playField == self:
		note.playField = null

func addNote(note):
	notes.push_back(note)
	if (note.isSustainNote):
		note.scale = Vector2(note.baseScaleX * scale, note.baseScaleY)
	note.playField = self

func forEachNote(callback:Callable):
	for note in notes:
		if (note != null && note.exists && note.alive):
			callback.call(note)
