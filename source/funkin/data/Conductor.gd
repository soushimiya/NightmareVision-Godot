extends Node

var bpm:float = 0:
	set(value):
		bpm = value
		crotchet = (60 / bpm) * 1000
		stepCrotchet = crotchet / 4

var crotchet:float
var stepCrotchet:float

var songPosition:float = 0
var lastSongPos:float = 0
var offset:float = 0

var safeZoneOffset:float = (ClientPrefs.safeFrames / 60) * 1000; # is calculated in create(), is safeFrames in milliseconds
var bpmChangeMap:Array = [];

func getBPMFromSeconds(time:float):
	var lastChange = {
		"stepTime": 0,
		"songTime": 0,
		"bpm": bpm,
		"stepCrotchet": stepCrotchet
	}
	for i in range(bpmChangeMap.size() - 1):
		if time >= bpmChangeMap[i].songTime:
			lastChange = bpmChangeMap[i];
	return lastChange
	
func mapBPMChanges(song):
	bpmChangeMap = []
	
	var curBPM:float = song.bpm
	var totalSteps:int = 0
	var totalPos:int = 0
	for i in range(song.notes.size() - 1):
		if song.notes[i].has("changeBPM") && song.notes[i].changeBPM && song.notes[i].bpm != curBPM:
			curBPM = song.notes[i].bpm
			var event= {
				"stepTime": totalSteps,
				"songTime": totalPos,
				"bpm": curBPM,
				"stepCrotchet": (60 / curBPM) * 1000
			}
			bpmChangeMap.append(event)
		
		var deltaSteps = round(getSectionBeats(song, i) * 4)
		totalSteps += deltaSteps
		totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps
		
	print("new BPM map BUDDY " + str(bpmChangeMap))

func getSectionBeats(song, section:int):
	if (song.notes[section].has("sectionBeats")):
		return song.notes[section].sectionBeats
	return 4
