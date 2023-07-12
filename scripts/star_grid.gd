extends TileMap

@onready var UI = $"../UI"
@onready var camera = get_parent().get_node("MainCamera")

var tile_position: Vector2
var star_names = Names.new()
var last_cam_pos: Vector2i

################################################################################
# Map resolution e tilemap cell details
################################################################################
var resolution = 4

var cells_width: int = 50
var cells_height: int = 37
var cells_offset_x: int = -14
var cells_offset_y: int = -8

################################################################################
# World Names in the hex grid
################################################################################
@export var star_name_position = Vector2(-190, 144)
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
# Create the proedural noises to use in random star position
################################################################################

var star_noises = FastNoiseLite.new()
var star_noises2 = FastNoiseLite.new()

@export var star_noises_frequency: float = 5
@export var octaves: int = 5
@export var lacunarity: float = 2.0
@export var gain: float = 0.5
@export var fractal_type: int = 2

@export var star_noises_frequency2: float = 0.01
@export var octaves2: int = 4
@export var lacunarity2: float = 101
@export var gain2: float = 0.5
@export var fractal_type2: int = 1

@export var star_frequence: float = 1.545
@export var star_frequence2: float = 0.365

@export var random: float = 0.2


func _ready():
	# This wait is to make sure the first map frame is generated right
	await get_tree().create_timer(0.1).timeout
	draw_tile()
	queue_redraw()


@warning_ignore("unused_parameter")
func _process(delta):
	noise_settings()
	if last_cam_pos != Vector2i(cam_x,cam_y):
		clear()
		queue_redraw()
		draw_tile()
		last_cam_pos = Vector2i(cam_x,cam_y)
	
	# Send mouse global position to show tile coornates Y and X in the UI labels.
	send_map_coord()
	


func noise_settings():
	star_noises.frequency = star_noises_frequency
	star_noises.fractal_octaves = octaves
	star_noises.fractal_lacunarity = lacunarity
	star_noises.fractal_gain = gain
	star_noises.fractal_type = fractal_type
	
	
	star_noises2.frequency = star_noises_frequency2
	star_noises2.fractal_octaves = octaves2
	star_noises2.fractal_lacunarity = lacunarity2
	star_noises2.fractal_gain = gain2
	star_noises2.fractal_type = fractal_type2


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
			
			var star_noise = star_noises.get_noise_2d(tile_position.x, tile_position.y)
			
			name_generator_position = local_to_map(Vector2(cam_x + i, cam_y + j))
			
			if get_cell_tile_data(0, tile_position):
				draw_star_names()


func draw_tile():
	for x in cells_width:
		for y in cells_height:
			procedural_seed(1, x, y)
			
			tile_position = Vector2(
				cam_x + x + cells_offset_x, cam_y + y + cells_offset_y
				)
			
			var star_noise = star_noises.get_noise_2d(tile_position.x, tile_position.y)
			var star_noise2 = star_noises2.get_noise_2d(tile_position.x, tile_position.y)
			
			print(get_cell_source_id(0, tile_position))
			if (abs(star_noise) > star_frequence + randommizing_stars(random) 
				or abs(star_noise2) > star_frequence2 + randommizing_stars(random)):
				set_cell(0, tile_position, 0, Vector2(0, 0))


func draw_star_names():
	var hex_name = str(star_names.generate_name()).left(8)
	draw_string(
		font, star_name_position_hex, hex_name, HORIZONTAL_ALIGNMENT_CENTER, 
		star_name_chars * name_width, font_size, Color.WHITE)
	draw_string_outline(font, star_name_position_hex, hex_name, HORIZONTAL_ALIGNMENT_CENTER, 
		star_name_chars * name_width, font_size, font_border, Color.BLACK)


func randommizing_stars(r):
	var ra = randf_range(-r, r)
	return ra


func camera_coord(cx: float, cy: float,):
	var coords = local_to_map(Vector2(cx, cy))
	cam_x = coords.x
	cam_y = coords.y


func send_map_coord():
	UI.coordinates(local_to_map(get_global_mouse_position()))

