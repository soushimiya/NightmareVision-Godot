extends MusicBeatState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var script = load("res://source/funkin/data/scripts/FunkinLua.tscn").instantiate()
	add_child(script)
	script.load(Paths.lua("stages/stage"), self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
