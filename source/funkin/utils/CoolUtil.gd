extends Node

static func bound(value:float, min:float, max:float) -> float:
	if value > max:
		return max
	if value < min:
		return min
		
	return value

static func formatTime(seconds:float, showMS:bool = false) -> String:
	var timeString:String = str(int(seconds / 60)) + ":"
	var timeStringHelper:int = int(seconds) % 60
	if timeStringHelper < 10:
		timeString += "0"
	timeString += str(timeStringHelper)
	if (showMS):
		timeString += "."
		timeStringHelper = int((seconds - int(seconds)) * 100)
		if (timeStringHelper < 10):
			timeString += "0"
		timeString += str(timeStringHelper)
	return timeString
