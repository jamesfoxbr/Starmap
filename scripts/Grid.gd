extends TileMap

@onready var UI = $"../UI"
@onready var camera = get_parent().get_node("MainCamera")

var tile_position: Vector2

var sector_name = Names.new()

################################################################################
# Map resolution e tilemap cell details
################################################################################
var resolution = 4

var cells_width: int = 50
var cells_height: int = 37

################################################################################
# More Variables
################################################################################
@export var star_name_position = Vector2(-210, 144)
var font = load("res://monofonto rg.otf")
var font_size = 52
var font_border: int = 4
@export var star_name_chars: int = 10
@export var name_width: int = 35

var star_name_position_hex
var name_generator_position: Vector2

var cam_x: int
var cam_y: int
var cam_zoom: float

################################################################################
# Draw hex grid lines variables
################################################################################
const top_left = Vector2(-96, -160)
const top_right = Vector2(96, -160)
const middle_left = Vector2(-192, 0)
const middle_right = Vector2(192, 0)
const bottom_left = Vector2(-96, 160)
const bottom_right = Vector2(96, 160)

const grid_width: int = 10
var grid_color = Color.html("#303030")


func _ready():
	# This wait is to make sure the first map frame is generated right
	await get_tree().create_timer(0.1).timeout
	queue_redraw()


@warning_ignore("unused_parameter")
func _process(delta):
	queue_redraw()


func procedural_seed(my_seed, i, j):
	seed(((cam_x + i) * (cam_x + i) * (cam_x + i) + 
	(cam_y + j) * (cam_y + j) + (cam_y + i) * (cam_y + j)) + my_seed)


func _draw():
	for x in cells_width:
		for y in cells_height:
			procedural_seed(1, x, y)
			
			tile_position = Vector2(cam_x + x, cam_y + y)
			star_name_position_hex = map_to_local(Vector2(cam_x + x, cam_y + y)) + star_name_position
			
			name_generator_position = local_to_map(Vector2(cam_x + x, cam_y + y))
			
			draw_subsector()
			draw_sector()
#			subsector_name((cam_x + x) * (cam_y + y))


func draw_subsector():
	# draw subsector retangles
	
	# This is the Vertical line
	if int(tile_position.x) % 8 == 0 and int(tile_position.y) % 10 == 0 and int(tile_position.y) % 15 == 0:
		draw_line(map_to_local(tile_position) + Vector2(-34, 0) * resolution,
		map_to_local(tile_position + Vector2(0, 1)) + Vector2(-34, -2000) * resolution, 
		grid_color, grid_width, false)
		draw_line(map_to_local(tile_position) + Vector2(-34, 0) * resolution,
		map_to_local(tile_position + Vector2(0, -1)) + Vector2(-34, 2000) * resolution, 
		grid_color, grid_width, false)
	
	# This is the Horizontal line
	if int(tile_position.y) % 10 == 0 and int(tile_position.x) % 8 == 0:
		draw_line(map_to_local(tile_position) + Vector2(0, 0),
		map_to_local(tile_position) + Vector2(550, 0)  * resolution, 
		grid_color, grid_width, false)
		draw_line(map_to_local(tile_position) + Vector2(0, 0),
		map_to_local(tile_position) + Vector2(-350, 0)  * resolution, 
		grid_color, grid_width, false)


func subsector_name(xy):
	if int(tile_position.x) % 8 ==0 and int(tile_position.y) % 10 ==0:
		var subsector_nam = str(sector_name.generate_name(xy)).left(8)
		draw_string(
			font, map_to_local(tile_position) + Vector2(0, -1500), subsector_nam, 
			HORIZONTAL_ALIGNMENT_CENTER, -1, 512, Color.html("#222222"))
	

func draw_sector():
	# draw subsector retangles
		
	# This is the Vertical line
	if int(tile_position.x) % 32 == 0 and int(tile_position.y) % 25 == 0:
		draw_line(map_to_local(tile_position) + Vector2(-34, 2000) * resolution,
		map_to_local(tile_position + Vector2(0, 1)) + Vector2(-34, 0) * resolution, 
		grid_color, grid_width + 20, false)
		draw_line(map_to_local(tile_position) + Vector2(-34, -2000) * resolution,
		map_to_local(tile_position + Vector2(0, 1)) + Vector2(-34, 0) * resolution, 
		grid_color, grid_width + 20, false)
		
	# This is the Horizontal line
	if int(tile_position.y) % 40 == 0 and  int(tile_position.x) % 2 == 0:
		draw_line(map_to_local(tile_position) + Vector2(0, 0),
		map_to_local(tile_position) + Vector2(150, 0)  * resolution, 
		grid_color, grid_width + 20, false)


func camera_coord(cx: float, cy: float,):
	var coords = local_to_map(Vector2(cx, cy))
	cam_x = coords.x
	cam_y = coords.y
