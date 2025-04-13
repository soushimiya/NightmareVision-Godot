extends Node

static func loadFromJson(jsonInput:String, folder:String):
	var formattedFolder:String = Paths.formatToSongPath(folder)
	var formattedSong:String = Paths.formatToSongPath(jsonInput)
	
	var path = Paths.json(formattedFolder + '/' + formattedSong, "songs");
	if Assets.exists(path):
		var rawJson = Assets.getText(path)
		var songJson = JSON.parse_string(rawJson).song
		onLoadJson(songJson)
		return songJson
	return {}

static func onLoadJson(songJson): # Convert old charts to newest format
	if (!songJson.has("gfVersion")):
		if (songJson.has("player3")):
			songJson.gfVersion = songJson.player3
			songJson.erase("player3")
		else:
			songJson.gfVersion = "gf"
		
	if (!songJson.has("keys")): songJson.keys = 4
	if (!songJson.has("lanes")): songJson.lanes = 2
	
	if (!songJson.has("events")):
		songJson.events = []
		
		for secNum in range(songJson.notes.size() - 1):
			var sec = songJson.notes[secNum]
			var i:int = 0;
			var notes = sec.sectionNotes;
			var len:int = notes.size();
			
			while i < len:
				var note = notes[i]
				if (note[1] < 0):
					songJson.events.push([note[0], [[note[2], note[3], note[4]]]])
					notes.remove(note)
					len = notes.length
				else:
					i += 1
			
