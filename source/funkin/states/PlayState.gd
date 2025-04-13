extends MusicBeatState

var curStage:String = 'stage';

var isStoryMode:bool = false;
var storyWeek:int = 0;
var storyPlaylist:Array = [];
var storyDifficulty:int = 1;

var camFollow:Vector2 = Vector2();

var prevCamFollow:Vector2;
var prevCamFollowPos:Node2D;

var camZooming:bool = false;
var camZoomingMult:float = 1;
var camZoomingDecay:float = 1;

var curSong:String = "";

var health:float = 0:
	set(value):
		if (health > 2):
			health = 2
		$playHUD.onHealthChange(value)
		health = value

var songPercent:float = 0;
var songLength:float = 0;

var combo:int = 0;

var epics:int = 0;
var sicks:int = 0;
var goods:int = 0;
var bads:int = 0;
var shits:int = 0;

var generatedMusic:bool = false;

var endingSong:bool = false;
var startingSong:bool = false;

var songScore:int = 0;
var songHits:int = 0;
var songMisses:int = 0;

static var campaignScore:int = 0;
static var campaignMisses:int = 0;
static var seenCutscene:int = 0;
static var deathCounter:int = 0;

var defaultCamZoomAdd:float = 0;
var defaultCamZoom:float = 1.05;
var defaultHudZoom:float = 1;
var beatsPerZoom:float = 4;

var inCutscene:bool = false;

var skipCountdown:bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	
	$camGame.global_position = $camFollowPos.global_position
	# this sucks but its ok """""for now"""""!!!!!
	Conductor.songPosition += (delta * 1000.0)
