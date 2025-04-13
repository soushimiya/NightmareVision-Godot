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
