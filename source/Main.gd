extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window := get_window()
	# fix of fucking macOS DPI
	if OS.get_name() == "macOS":
		window.size = Vector2i(1280*2, 720*2)
		
	window.move_to_center()
	#Global.switchState()
