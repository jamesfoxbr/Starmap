extends CanvasLayer

var y: String
var x: String

@onready var UI = $Control/VBoxContainer/ColorRect/Coordinates/Y

func _process(delta):
	UI.text = "   X: " + x + "  Y: " + y

func coordinates(coord):
	y = str(floor(coord.y))
	x = str(floor(coord.x))
