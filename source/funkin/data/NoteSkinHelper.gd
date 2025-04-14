extends Node
class_name NoteSkinHelper

const defaultTexture:String = 'NOTE_assets'
const defaultSplashTexture:String = 'noteSplashes'

const defaultNoteAnimations:Array = [
	[
		{
			"color": "purple",
			"anim": "purpleScroll",
			"xmlName": "purple",
			"offsets": [0, 0]
		},
		{
			"color": "purple",
			"anim": "purplehold",
			"xmlName": "purple hold piece",
			"offsets": [0, 0]
		},
		{
			"color": "purple",
			"anim": 'purpleholdend',
			"xmlName": 'pruple end hold',
			"offsets": [0, 0]
		}
	],
	[
		{
			"color": "blue",
			"anim": "blueScroll",
			"xmlName": "blue",
			"offsets": [0, 0]
		},
		{
			"color": "blue",
			"anim": "bluehold",
			"xmlName": "blue hold piece",
			"offsets": [0, 0]
		},
		{
			"color": "blue",
			"anim": "blueholdend",
			"xmlName": "blue hold end",
			"offsets": [0, 0]
		}
	],
	[
		{
			"color": "green",
			"anim": "greenScroll",
			"xmlName": "green",
			"offsets": [0, 0]
		},
		{
			"color": "green",
			"anim": "greenhold",
			"xmlName": "green hold piece",
			"offsets": [0, 0]
		},
		{
			"color": "green",
			"anim": "greenholdend",
			"xmlName": "green hold end",
			"offsets": [0, 0]
		}
	],
	[
		{
			"color": "red",
			"anim": "redScroll",
			"xmlName": "red",
			"offsets": [0, 0]
		},
		{
			"color": "red",
			"anim": "redhold",
			"xmlName": "red hold piece",
			"offsets": [0, 0]
		},
		{
			"color": "red",
			"anim": "redholdend",
			"xmlName": "red hold end",
			"offsets": [0, 0]
		}
	]
]

const defaultReceptorAnimations:Array = [
	[
		{
			"color": "",
			"anim": 'static',
			"xmlName": "arrowLEFT",
			"offsets": [0, 0]
		},
		{
			"color": "",
			"anim": "pressed",
			"xmlName": "left press",
			"offsets": [0, 0]
		},
		{
			"color": "",
			"anim": "confirm",
			"xmlName": "left confirm",
			"offsets": [0, 0]
		}
	],
	[
		{
			"color": "",
			"anim": "static",
			"xmlName": "arrowDOWN",
			"offsets": [0, 0]
		},
		{
			"color": "",
			"anim": "pressed",
			"xmlName": "down press",
			"offsets": [0, 0]
		},
		{
			"color": "",
			"anim": "confirm",
			"xmlName": "down confirm",
			"offsets": [0, 0]
		}
	],
	[
		{
			"color": "",
			"anim": "static",
			"xmlName": "arrowUP",
			"offsets": [0, 0]
		},
		{
			"color": "",
			"anim": "pressed",
			"xmlName": "up press",
			"offsets": [0, 0]
		},
		{
			"color": "",
			"anim": "confirm",
			"xmlName": "up confirm",
			"offsets": [0, 0]
		}
	],
	[
		{
			"color": "",
			"anim": "static",
			"xmlName": "arrowRIGHT",
			"offsets": [0, 0]
		},
		{
			"color": "",
			"anim": "pressed",
			"xmlName": "right press",
			"offsets": [0, 0]
		},
		{
			"color": "",
			"anim": "confirm",
			"xmlName": "right confirm",
			"offsets": [0, 0]
		}
	]
]

const defaultNoteSplashAnimations:Array = [
	{"anim": "note0", "xmlName": "note splash purple", "offsets": [0, 0]},
	{"anim": "note1", "xmlName": "note splash blue", "offsets": [0, 0]},
	{"anim": "note2", "xmlName": "note splash green", "offsets": [0, 0]},
	{"anim": "note3", "xmlName": "note splash red", "offsets": [0, 0]}
]

const fallbackReceptorAnims:Array = [
	{
		"color": "",
		"anim": 'static',
		"xmlName": "placeholder",
		"offsets": [0, 0]
	},
	{
		"color": "",
		"anim": "pressed",
		"xmlName": "placeholder",
		"offsets": [0, 0]
	},
	{
		"color": "",
		"anim": "confirm",
		"xmlName": "placeholder",
		"offsets": [0, 0]
	}
]

const defaultSingAnimations:Array = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT']

var data:Dictionary

func _init(path:String) -> void:
	data = JSON.parse_string(Assets.getText(path))
	resolveData(data)
	
func resolveData(data):
	if (!data.has("globalSkin")): data.globalSkin = defaultTexture
	
	if (!data.has("playerSkin")): data.playerSkin = data.globalSkin
	if (!data.has("opponentSkin")): data.opponentSkin = data.globalSkin
	if (!data.has("extraSkin")): data.extraSkin = data.globalSkin
	
	if (!data.has("noteSplashSkin")): data.noteSplashSkin = defaultSplashTexture
	if (!data.has("hasQuants")): data.hasQuants = false
	
	if (!data.has("noteAnimations")): data.noteAnimations = defaultNoteAnimations
	if (!data.has("receptorAnimations")): data.noteAnimations = defaultReceptorAnimations
	if (!data.has("noteSplashAnimations")): data.noteAnimations = defaultNoteSplashAnimations
	if (!data.has("singAnimations")): data.singAnimations = defaultSingAnimations
