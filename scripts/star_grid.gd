extends TileMap

@export var grid_size: int = 20

var cam_x: int
var cam_y: int

@export var star_chance: int = 30		# Chance of star generation per square. Read 10 like 10% for example.

func _ready():
	pass

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_anything_pressed():
		clear()
	
	generate_stars()


func generate_stars():
	for i in floor(grid_size * 1.6):
		for j in grid_size:
			var tile_position = Vector2i(cam_x + i, cam_y + j)
			seed((cam_x + i) * (cam_x + i) * (cam_x + i) 
			+ (cam_y + j) * (cam_y + j) + (cam_x + i) * (cam_y + j))
			if rand100() < star_chance:
				set_cell(0, tile_position, 0, Vector2i(0, 0), 0)
			else:
				set_cell(0, Vector2i(floor(cam_x + i), floor(cam_y + j)), 1, Vector2i(7, 0))


func rand100():
	var random100: int = floor(randf_range(1,100))
	return random100


func camera_coord(cx: float, cy: float):
	cam_x = floor(cx)
	cam_y = floor(cy)
