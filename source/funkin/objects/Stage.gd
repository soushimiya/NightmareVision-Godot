extends Node2D

@export var stageName:String = "stage"

var stageData = {}

# Called when the node enters the scene tree for the first time.
func init() -> void:
	stageData = JSON.parse_string(Assets.getText(Paths.json(stageName, "stages")))
	
	# if Assets.exists(Paths.lua("stages/" + stageName)):
		# var luaScript = load("res://source/funkin/data/scripts/FunkinLua.tscn").instantiate()
		# add_child(luaScript)
		# luaScript.lua.globals["foreground"] = get_node("../foreground")
		# luaScript.load(Paths.lua("stages/" + stageName), self)
