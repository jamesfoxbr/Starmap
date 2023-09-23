extends CanvasLayer

var star_names = Names.new()

var y: String
var x: String

@onready var UI = $Control/VBoxContainer/ColorRect2/Coordinates
@onready var star_name = $Control/VBoxContainer/ColorRect2/StarName

@warning_ignore("unused_parameter")
func _process(delta):
	UI.text = "MOUSE COORDINATES:  X " + x + "  Y " + y
	star_name.text = "Star Name: " 


func coordinates(coord):
	y = str(floor(coord.y))
	x = str(floor(coord.x))
