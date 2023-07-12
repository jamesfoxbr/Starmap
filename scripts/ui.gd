extends CanvasLayer

var y: String
var x: String

@onready var UI = $Control/VBoxContainer/ColorRect2/Coordinates

@warning_ignore("unused_parameter")
func _process(delta):
	UI.text = "COORDINATES:    X " + x + "  Y " + y

func coordinates(coord):
	y = str(floor(coord.y))
	x = str(floor(coord.x))
