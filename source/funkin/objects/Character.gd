extends AnimatedSprite2D

var voicelining:bool = false
var idleAnims:Array = ['idle']

@export var isPlayer:bool = false
@export var curCharacter:String = "bf"
var holdTimer:float = 0
var heyTimer:float = 0
var animTimer:float = 0
var specialAnim:bool = false
var singDuration:float = 4 # Multiplier of how long a character holds the sing pose
var danceIdle:bool = false # Character use "danceLeft" and "danceRight" instead of "idle"

var healthIcon:String = 'face'
var positionArray:Array = [0, 0];
var healthColorArray:Array = [255, 0, 0];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Assets.exists(Paths.json(curCharacter, "characters")):
		curCharacter = "bf"
		
	var json = JSON.parse_string(Assets.getText(Paths.json(curCharacter, "characters")))
	
	self.scale = Vector2(json.scale, json.scale)
	self.positionArray = json.position
	self.healthIcon = json.healthicon
	self.singDuration = json.sing_duration
	self.flip_h = json.flip_x
	if json.no_antialiasing:
		self.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	self.healthColorArray = json.healthbar_colors
	if isPlayer:
		self.flip_h = !self.flip_h;
	
	sprite_frames = load("res://assets/shared/images/"+ json.image +".xml")
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
