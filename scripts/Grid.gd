extends TileMap

@onready var UI = $"../UI"
@onready var grid = $Grid
@onready var camera = get_parent().get_node("MainCamera")
@onready var subsector_names = $"../SubsectorNames"

var tile_position: Vector2

var sector_name = Names.new()

################################################################################
# Map resolution e tilemap cell details
################################################################################
var resolution = 4

var cells_width: int = 50
var cells_height: int = 37
var cells_offset_x: int = -14
var cells_offset_y: int = -8

var last_cam_pos: Vector2i
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
	if last_cam_pos != Vector2i(cam_x,cam_y):
		queue_redraw()
		last_cam_pos = Vector2i(cam_x,cam_y)


func procedural_seed(my_seed, i, j):
	seed(((cam_x + i) * (cam_x + i) * (cam_x + i) + (cam_y + j) * (cam_y + j) + (cam_x + i) * (cam_y + j)))


func _draw():
	for i in cells_width:
		for j in cells_height:
			procedural_seed(1, i, j)
			
			tile_position = Vector2(
				cam_x + i + cells_offset_x, cam_y + j + cells_offset_y)
			star_name_position_hex = map_to_local(
				Vector2(
					cam_x + i + cells_offset_x, cam_y + j + cells_offset_y
					)) + star_name_position
			
			
			name_generator_position = local_to_map(Vector2(cam_x + i, cam_y + j))
			
			draw_hex_grid(grid_width, grid_color)
			draw_subsector()
			draw_sector()
			subsector_name()


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


func subsector_name():
	if int(tile_position.x) % 8 ==0 and int(tile_position.y) % 10 ==0:
		var subsector_name = str(sector_name.generate_name()).left(8)
		draw_string(
			font, map_to_local(tile_position) + Vector2(0, -1500), subsector_name, 
			HORIZONTAL_ALIGNMENT_CENTER, -1, 512, Color.html("#151515"))
	

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


func draw_hex_grid(grid_wid, grid_col):
	# Draw hex grid
	var hex_points = PackedVector2Array([
		top_left + map_to_local(tile_position), 
		middle_left + map_to_local(tile_position), 
		bottom_left + map_to_local(tile_position),
		bottom_right + map_to_local(tile_position), 
		middle_right + map_to_local(tile_position), 
		top_right + map_to_local(tile_position), 
		top_left + map_to_local(tile_position)])
	
	draw_polyline(hex_points, grid_col, grid_wid)


func my_rand(min, max):
	var random100: int = floor(randf_range(min, max))
	return random100


func camera_coord(cx: float, cy: float,):
	var coords = local_to_map(Vector2(cx, cy))
	cam_x = coords.x
	cam_y = coords.y
