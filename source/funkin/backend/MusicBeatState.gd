extends Node2D
class_name MusicBeatState

var curSection:int = 0;
var stepsToDo:int = 0;

var curStep:int = 0;
var curBeat:int = 0;

var curDecStep:float = 0;
var curDecBeat:float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var oldStep:int = curStep
	updateCurStep()
	updateBeat()
	
	if (oldStep != curStep):
		if (curStep > 0):
			stepHit()

func updateCurStep():
	var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition)

	var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrotchet
	curDecStep = lastChange.stepTime + shit
	curStep = lastChange.stepTime + floorf(shit)

func updateBeat():
	curBeat = floor(curStep / 4)
	curDecBeat = curDecStep / 4

func stepHit():
	if (curStep % 4 == 0):
		beatHit()
		
func beatHit():
	pass

func switchState(state:MusicBeatState):
	get_node("/root/Main/game").add_child(state.instantiate())
	self.queue_free()
