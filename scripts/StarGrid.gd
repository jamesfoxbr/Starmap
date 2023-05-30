extends TileMap

var mouse_click

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		mouse_click = get_cell_atlas_coords(0, get_global_mouse_position())
		
	print(mouse_click)
