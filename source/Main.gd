extends Node2D

# Called when the node enters the scene tree for the first time.
static var initalState = preload("res://source/Splash.tscn")
#static var initalState = preload("res://source/funkin/states/PlayState.tscn")
func _ready() -> void:
	var window := get_window()
	# fix of fucking macOS DPI
	if OS.get_name() == "macOS":
		window.size = Vector2i(1280*2, 720*2)
		
	window.move_to_center()
	
	# Move them into FreeplayState after i implement them
	PlayState.SONG = Song.loadFromJson("bopeebo-hard", "bopeebo")
	$game.add_child(initalState.instantiate())
	
func _process(delta: float) -> void:
	$fpsVar/text.text = "FPS: " + str(Engine.get_frames_per_second()) + " • Memory: " + str(OS.get_static_memory_usage() / (1024 * 1024)) + "MB"
