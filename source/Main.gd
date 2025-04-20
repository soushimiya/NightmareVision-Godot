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
	PlayState.SONG = Song.loadFromJson("silly-billy", "silly-billy")
	$game.add_child(initalState.instantiate())
	
# change this when i make custom transition stuff
@export var fuckingFill:float = -60.0
func _process(delta: float) -> void:
	$fpsVar/text.text = "FPS: " + str(Engine.get_frames_per_second()) + " • Memory: " + str(OS.get_static_memory_usage() / (1024 * 1024)) + "MB"
	
	$transition/rect.texture.fill_from.y = fuckingFill
	
func playSound(path):
	$sound.stream = Assets.getSound(path)
	$sound.play()
func _on_sound_finished() -> void:
	$sound.stream = null
	$sound.volume_db = 0

func playMusic(path):
	$music.stream = Assets.getSound(path)
	$music.play()
# loop stuff
func _on_music_finished() -> void:
	if $music.stream != null:
		$music.play()
