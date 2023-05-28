extends Camera2D

var cell_number = load("res://scenes/Interface.tscn")
@onready var tilemap = get_node("../StarGrid")

func _ready():
	pass

func  _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= event.relative * zoom
			
func _process(delta):
	var cell_total = tilemap.get_used_cells(0).size()
	var instance = cell_number.instantiate()
	add_child(instance)
