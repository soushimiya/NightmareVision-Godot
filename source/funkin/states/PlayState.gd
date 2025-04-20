extends MusicBeatState
class_name PlayState

static var SONG = null

const STRUM_X:float = 42
const STRUM_X_MIDDLESCROLL:float = -278

var boyfriendCameraOffset = Vector2()
var opponentCameraOffset = Vector2()
var girlfriendCameraOffset = Vector2()

var songSpeed:float = 1:
	set(value):
		songSpeed = value
		var ratio:float = value / songSpeed; # funny word huh
		for note in $hud/notes.get_children():
			note.resizeByRatio(ratio)
		for note in unspawnNotes:
			note.resizeByRatio(ratio)

var curStage:String = 'stage'

static var isStoryMode:bool = false
static var storyWeek:int = 0
static var storyPlaylist:Array = []
static var storyDifficulty:int = 1

var unspawnNotes:Array = []

var camFollow:Vector2 = Vector2()
var camFollowTarget

var prevCamFollow:Vector2
var prevCamFollowPos:Node2D

var camZooming:bool = true
var camZoomingMult:float = 1
var camZoomingDecay:float = 1

var curSong:String = ""

var health:float = 0:
	set(value):
		health = value
		if (health > 2):
			health = 2
		playHUD.onHealthChange(value)

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
var beatsPerZoom:int = 4

var inCutscene:bool = false

var skipCountdown:bool = false

@onready var playHUD = $hud/playHUD

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
	$/root/Main/music.stop()
	
	if (SONG == null):
		SONG = Song.loadFromJson('test', 'tutorial')
		
	songSpeed = SONG.speed
	
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
		
	for section in SONG.notes:
		for songNotes in section.sectionNotes:
			var daStrumTime:float = songNotes[0]
			var daNoteData:int = int(songNotes[1]) % int(SONG.keys)
			var gottaHitNote:bool = section.mustHitSection
			if songNotes[1] > (SONG.keys - 1):
				gottaHitNote = !gottaHitNote
			
			var daPlayer = 0
			if gottaHitNote:
				daPlayer = 1
				
			var oldNote:Note = null
			var swagNote = Note.new(daStrumTime, daNoteData, oldNote, false, daPlayer)
			swagNote.mustPress = gottaHitNote
			swagNote.sustainLength = songNotes[2]
			#swagNote.gfNote = (section.has("gfSection") && section.gfSection && (songNotes[1] < SONG.keys))
			#swagNote.noteType = songNotes[3]
			unspawnNotes.push_back(swagNote)
			
			var susLength:float = swagNote.sustainLength
			susLength = susLength / Conductor.stepCrotchet
			
			var floorSus:int = round(susLength)
			if (floorSus > 0):
				for susNote in range(floorSus + 1):
					oldNote = unspawnNotes[int(unspawnNotes.size() - 1)]
					var sustainNote = Note.new(daStrumTime
							+ (Conductor.stepCrotchet * susNote)
							+ (Conductor.stepCrotchet / songSpeed), daNoteData,
							oldNote, true, daPlayer)

					sustainNote.mustPress = swagNote.mustPress
					var dataToCheck:int = songNotes[1];
					if (SONG.lanes > 1):
						if (gottaHitNote): swagNote.lane = 0
						if (!gottaHitNote): swagNote.lane = 1

						if (dataToCheck > int((SONG.keys * 2) - 1)): swagNote.lane = int(max(floor(dataToCheck / SONG.keys), -1))
					else:
						swagNote.lane = 0
					#sustainNote.gfNote = swagNote.gfNote
					#sustainNote.noteType = songNotes[3]
					sustainNote.lane = swagNote.lane
					swagNote.tail.push_back(sustainNote)
					unspawnNotes.push_back(swagNote)
					
			if (swagNote.mustPress):
				swagNote.position.x += 1280 / 2 # general offset
			else: if (ClientPrefs.middleScroll):
					swagNote.position.x += 310;
					if (daNoteData > 1): # Up and Right
						swagNote.position.x += 1280 / 2 + 25
	unspawnNotes.sort_custom(func(a:Note, b:Note): return a.strumTime < b.strumTime)
	
	songLength = $inst.stream.get_length()*10
	generatedMusic = true
	
	if (!SONG.has("stage")):
		SONG.stage = 'stage'
	else:
		curStage = SONG.stage
		
	$stage.stageName = curStage
	$stage.init()
	setStageData($stage.stageData)
	
	$boyfriend.curCharacter = SONG.player1
	$dad.curCharacter = SONG.player2

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
	if camFollowTarget == target:
		return
	var desiredPos = getCharacterCameraPos(target)
	camFollow = Vector2(target.global_position.x + desiredPos.x, target.global_position.y + desiredPos.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	
	if Input.is_action_pressed("ui_left"):
		moveCamera(true)
	if Input.is_action_pressed("ui_right"):
		moveCamera(false)
	
	if ($inst.playing):
		var instTime = $inst.get_playback_position() + AudioServer.get_time_since_last_mix()
		Conductor.songPosition = (instTime * 1000.0)
	
	
	songPercent = Conductor.songPosition / songLength
	
	$camGame.global_position = $camFollowPos.global_position
	if camZooming:
		$camGame.zoom.x = lerp(defaultCamZoom + defaultCamZoomAdd, $camGame.zoom.x, exp(-delta * 6.25 * camZoomingDecay))
		$hud.scale.x = lerp(defaultHudZoom, $hud.scale.x, exp(-delta * 6.25 * camZoomingDecay))
	$camGame.zoom.y = $camGame.zoom.x
	$hud.scale.y = $hud.scale.x
	# lazy fix of canvaslayer offsetting
	$hud.offset.x = (-1280/2)*($hud.scale.x-1)
	$hud.offset.y = (-720/2)*($hud.scale.y-1)
	
	if !inCutscene:
		var lerpVal = CoolUtil.bound(delta * 2.4 * cameraSpeed, 0, 1)
		$camFollowPos.position = Vector2(lerp($camFollowPos.position.x, camFollow.x, lerpVal), lerp($camFollowPos.position.y, camFollow.y, lerpVal))
	
	if unspawnNotes[0] != null:
		var time:float = 3000 # shit be werid on 4:3
		if (songSpeed < 1):
			time /= songSpeed
			
		for note in unspawnNotes:
			if (note.strumTime - Conductor.songPosition < time && !note.spawned):
				unspawnNotes.erase(note)
				var desiredPlayfield = $hud/playFields.get_child(note.lane)
				if (desiredPlayfield != null): $hud/playFields.get_child(note.lane).addNote(note)
				$hud/notes.add_child(note)
				note.spawned = true
				
	if generatedMusic:
		var fakeCrochet:float = (60 / SONG.bpm) * 1000
		
		for daNote in $hud/notes.get_children():
			if (daNote.lane > (SONG.lanes - 1)): continue
			var field = daNote.playField
			
			var strumX:float = field.get_children(daNote.noteData).global_position.x
			var strumY:float = field.get_children(daNote.noteData).global_position.y
			#var strumAngle:float = field.get_children(daNote.noteData).angle
			var strumDirection:float = field.get_children(daNote.noteData).direction
			#var strumAlpha:float = field.get_children(daNote.noteData).alpha
			var strumScroll:float = field.get_children(daNote.noteData).downScroll
			
			strumX += daNote.offsetX * (daNote.scale.x / daNote.baseScaleX);
			strumY += daNote.offsetY
			
			if (strumScroll): #Downscroll
				daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed)
			else: #Upscroll
				daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed)
				
			daNote.global_position.x = strumX + cos(strumDirection * PI / 180) * daNote.distance;
			daNote.global_position.y = strumY + sin(strumDirection * PI / 180) * daNote.distance
			
func stepHit():
	super()
	playHUD.stepHit()
	
func beatHit():
	super()
	if camZooming && ClientPrefs.camZooms && (curBeat % beatsPerZoom) == 0:
		$camGame.zoom.x += 0.015 * camZoomingMult
		$hud.scale.x += 0.03 * camZoomingMult
		
	if curBeat % 2 == 0:
		$boyfriend.playAnim("idle", true)
		$dad.playAnim("idle", true)
		playHUD.beatHit()

func sectionHit():
	super()
	playHUD.sectionHit()
