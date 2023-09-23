extends TileMap

################################################################################
# 
# DRAW HEX GRIDS
#
################################################################################

var tile_position: Vector2

@onready var camera = get_parent().get_node("MainCamera")
var cam_x: int
var cam_y: int

################################################################################
# Map resolution e tilemap cell details
################################################################################
var resolution = 4

var cells_width: int = 56
var cells_height: int = 39

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
	pass # Replace with function body.


func _process(delta):
	queue_redraw()


func _draw():
	for i in cells_width:
		for j in cells_height:
			tile_position = Vector2(
				cam_x + i, cam_y + j)
			
			draw_hex_grid(grid_width, grid_color)


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


func camera_coord(cx: float, cy: float,):
	var coords = local_to_map(Vector2(cx, cy))
	cam_x = coords.x
	cam_y = coords.y
