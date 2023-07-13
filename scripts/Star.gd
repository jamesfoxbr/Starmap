extends Node2D

@onready var nam = Names.new()

func _ready():	
	seed(position.x + position.y)
	var star_name = nam.generate_name()
	$StarName.text = star_name
	name = star_name


