extends AnimatedSprite2D
class_name MainMenuButton

var callback:Callable
var key:String

func _init(key:String, callback:Callable) -> void:
	self.callback = callback
	sprite_frames = load(Paths.xml("mainmenu/menu_" + key, "images"))
	sprite_frames.set_animation_loop(key + " basic", true)
	sprite_frames.set_animation_loop(key + " white", true)
	self.key = key
	
func _ready() -> void:
	play(key + " basic")
