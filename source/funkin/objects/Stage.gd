extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var luaScript = load("res://source/funkin/data/scripts/FunkinLua.tscn").instantiate()
	add_child(luaScript)
	luaScript.lua.globals["foreground"] = get_node("../foreground")
	luaScript.load(Paths.lua("stages/stage"), self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
