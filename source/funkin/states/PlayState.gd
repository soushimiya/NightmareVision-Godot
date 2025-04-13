extends MusicBeatState
class_name PlayState

static var SONG = null

var boyfriendCameraOffset = Vector2();
var opponentCameraOffset = Vector2();
var girlfriendCameraOffset = Vector2();

var curStage:String = 'stage'

var isStoryMode:bool = false
var storyWeek:int = 0
var storyPlaylist:Array = []
var storyDifficulty:int = 1

var camFollow:Vector2 = Vector2()

var prevCamFollow:Vector2
var prevCamFollowPos:Node2D

var camZooming:bool = false
var camZoomingMult:float = 1
var camZoomingDecay:float = 1

var curSong:String = ""

var health:float = 0:
	set(value):
		if (health > 2):
			health = 2
		$playHUD.onHealthChange(value)
		health = value

var songLength:float = 0
var songPercent:float = 0
var secondsTotal:int = 0

var combo:int = 0

var epics:int = 0
var sicks:int = 0
var goods:int = 0
var bads:int = 0
var shits:int = 0

var generatedMusic:bool = false

var endingSong:bool = false
var startingSong:bool = false

var cameraSpeed:float = 1

var songScore:int = 0
var songHits:int = 0
var songMisses:int = 0

static var campaignScore:int = 0
static var campaignMisses:int = 0
static var seenCutscene:int = 0
static var deathCounter:int = 0

var defaultCamZoomAdd:float = 0
var defaultCamZoom:float = 1.05
var defaultHudZoom:float = 1
var beatsPerZoom:float = 4

var inCutscene:bool = false

var skipCountdown:bool = false

func setStageData(stageData):
	defaultCamZoom = stageData.defaultZoom
	$camGame.zoom.x = defaultCamZoom
	
	$boyfriend.position += Vector2(stageData.boyfriend[0], stageData.boyfriend[1])
	#$gf.position = Vector2(stageData.girlfriend[0], stageData.girlfriend[1])
	$dad.position += Vector2(stageData.opponent[0], stageData.opponent[1])
	
	if (stageData.has("camera_speed")):
		cameraSpeed = stageData.camera_speed
	
	if (stageData.has("camera_boyfriend")):
		boyfriendCameraOffset = Vector2(stageData.camera_boyfriend[0], stageData.camera_boyfriend[1])
	if (stageData.has("camera_opponent")):
		opponentCameraOffset = Vector2(stageData.camera_opponent[0], stageData.camera_opponent[1])
	if (stageData.has("camera_girlfriend")):
		girlfriendCameraOffset = Vector2(stageData.camera_girlfriend[0], stageData.camera_girlfriend[1])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if (SONG == null):
		SONG = Song.loadFromJson('test', 'tutorial')
	
	Conductor.mapBPMChanges(SONG)
	Conductor.bpm = SONG.bpm
	
	$inst.stream = Assets.getSound(Paths.inst(SONG.song))
	$inst.play()
	# Vocals
	if (SONG.has("needsVoices") && SONG.needsVoices):
		var playerSound = Paths.voices(PlayState.SONG.song, 'player')
		if (!Assets.exists(playerSound)):
			playerSound = Paths.voices(PlayState.SONG.song)
		var playerVoices = AudioStreamPlayer.new()
		playerVoices.stream = Assets.getSound(playerSound)
		$voices.add_child(playerVoices)
		
		var opponentSound = Paths.voices(PlayState.SONG.song, 'opp')
		if (Assets.exists(opponentSound)):
			var opponentVoices = AudioStreamPlayer.new()
			opponentVoices.stream = Assets.getSound(opponentVoices)
			$voices.add_child(opponentVoices)

	for voice in $voices.get_children():
		voice.play()

	songLength = $inst.stream.get_length()*10
	
	if (!SONG.has("stage")):
		SONG.stage = 'stage'
	else:
		curStage = SONG.stage
		
	$stage.stageName = curStage
	$stage.init()
	setStageData($stage.stageData)

func getCharacterCameraPos(char):
	var desiredPos = Vector2(char.getTexture().get_width()/2, char.getTexture().get_height()/2)
	if (char.isPlayer):
		desiredPos.x -= 100 + (char.cameraPosition.x - boyfriendCameraOffset.x)
		desiredPos.y += -100 + char.cameraPosition.y + boyfriendCameraOffset.y
	else:
		desiredPos.x += 150 + char.cameraPosition.x + opponentCameraOffset.x
		desiredPos.y += -100 + char.cameraPosition.y + opponentCameraOffset.y
	return desiredPos

# Todo: use opponentStrums.owner
func moveCamera(isDad:bool):
	var target = $boyfriend
	if (isDad):
		target = $dad
	
	var desiredPos = getCharacterCameraPos(target)
	camFollow = Vector2(target.global_position.x + desiredPos.x, target.global_position.y + desiredPos.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	
	if Input.is_action_pressed("ui_left"):
		moveCamera(true)
	if Input.is_action_pressed("ui_right"):
		moveCamera(false)
		
	# this sucks but its ok """""for now"""""!!!!!
	Conductor.songPosition += (delta * 1000.0)
	songPercent = Conductor.songPosition / songLength
	
	$camGame.global_position = $camFollowPos.global_position
	if camZooming:
		$camGame.zoom.x = lerp(defaultCamZoom + defaultCamZoomAdd, $camGame.zoom.x, exp(-delta * 6.25 * camZoomingDecay));
	$camGame.zoom.y = $camGame.zoom.x
	
	if !inCutscene:
		var lerpVal = CoolUtil.bound(delta * 2.4 * cameraSpeed, 0, 1)
		$camFollowPos.position = Vector2(lerp($camFollowPos.position.x, camFollow.x, lerpVal), lerp($camFollowPos.position.y, camFollow.y, lerpVal))

func stepHit():
	super()
	$playHUD.stepHit()
	
func beatHit():
	super()
	$boyfriend.playAnim("idle", true)
	$dad.playAnim("idle")
	$playHUD.beatHit()

func sectionHit():
	super()
	$playHUD.sectionHit()
