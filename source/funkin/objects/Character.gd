extends AnimatedSprite2D

var voicelining:bool = false
var idleAnims:Array = ['idle']
var animations:Dictionary = {}

@export var isPlayer:bool = false
@export var curCharacter:String = "bf"
var curAnim:String = "idle"
var holdTimer:float = 0
var heyTimer:float = 0
var animTimer:float = 0
var specialAnim:bool = false
var singDuration:float = 4 # Multiplier of how long a character holds the sing pose
var danceIdle:bool = false # Character use "danceLeft" and "danceRight" instead of "idle"

var healthIcon:String = 'face'
var healthColor:Color = Color()
var cameraPosition:Vector2 = Vector2()
var positionData:Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Assets.exists(Paths.json(curCharacter, "characters")):
		curCharacter = "bf"
		
	var json = JSON.parse_string(Assets.getText(Paths.json(curCharacter, "characters")))
	
	self.scale = Vector2(json.scale, json.scale)
	self.position = Vector2(json.position[0], json.position[1])
	self.cameraPosition = Vector2(json.camera_position[0], json.camera_position[1])
	self.healthIcon = json.healthicon
	self.singDuration = json.sing_duration
	self.flip_h = json.flip_x
	if json.no_antialiasing:
		self.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	self.healthColor = Color8(json.healthbar_colors[0], json.healthbar_colors[1], json.healthbar_colors[2])
	if isPlayer:
		self.flip_h = !self.flip_h
	for anim in json.animations:
		self.animations.set(anim.anim, anim)
	
	sprite_frames = load("res://assets/shared/images/"+ json.image +".xml")
	playAnim(idleAnims[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func playAnim(name:String, force:bool = false, reversed:bool = false, frame:int = 0) -> void:
	if !animations.has(name):
		name = "idle"

	if force:
		stop()
	curAnim = name
	play(animations.get(name).name.trim_suffix("0"), animations.get(name).fps / 24, reversed)
	if frame > 0:
		set_frame_and_progress(frame, 0)
	# offsets sucks and i hate em
	offset = Vector2(-animations.get(name).offsets[0]*-1, animations.get(name).offsets[1]*-1)
	#trim_suffix

func getTexture():
	return sprite_frames.get_frame_texture(animations.get(idleAnims[0]).name.trim_suffix("0"), 0)
