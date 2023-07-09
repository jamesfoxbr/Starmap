extends CanvasLayer

var y: String
var x: String

@onready var UI = $Control/VBoxContainer/ColorRect/Coordinates/Y

func _process(delta):
	UI.text = "Y: " + y + "   X: " + x

func coordinates(coord_x, coord_y):
	y = str(floor(coord_y))
	x = str(floor(coord_x))
