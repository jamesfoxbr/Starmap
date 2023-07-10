extends TileMap

@onready var UI = $"../UI"

var tile_position: Vector2

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
@export var star_name_position = Vector2(-210, 154)
var font = load("res://monofonto rg.otf")
var font_size = 52
var font_border: int = 4
@export var star_name_chars: int = 12
@export var name_width: int = 35

var star_name_position_hex
var name_generator_position: Vector2

var cam_x: int
var cam_y: int
var cam_zoom: float

################################################################################
# Draw hex grid lines variables
################################################################################
var top_left = Vector2(-24, -40) * resolution
var top_right = Vector2(24, -40) * resolution
var middle_left = Vector2(0, 0) * resolution
var middle_right = Vector2(48, 1) * resolution
var bottom_left = Vector2(-24, 40) * resolution
var bottom_right = Vector2(24, 43) * resolution

var grid_width: int = 10
var grid_color = Color.html("#303030")

################################################################################
# Create the proedural noises to use in random star position
################################################################################

var star_noises = FastNoiseLite.new()
var star_noises2 = FastNoiseLite.new()

@export var star_noises_frequency: float = -0.173
@export var octaves: int = 5
@export var lacunarity: float = 2.0
@export var gain: float = 500

@export var star_noises_frequency2: float = 0.01
@export var octaves2: int = 4
@export var lacunarity2: float = 101
@export var gain2: float = 0.5

@export var star_frequence: int = 100
@export var star_frequence2: int = 150

@export var random: float = 75


func _ready():
	# This wait is to make sure the first map frame is generated right
	await get_tree().create_timer(0.1).timeout
	draw_tile()
	queue_redraw()


@warning_ignore("unused_parameter")
func _process(delta):
	noise_settings()	
	
	if Input.is_anything_pressed():
		clear()
		queue_redraw()
		draw_tile()
	
	# Send mouse global position to show tile coornates Y and X in the UI labels.
	send_map_coord()


func noise_settings():
	star_noises.frequency = star_noises_frequency
	star_noises.fractal_octaves = octaves
	star_noises.fractal_lacunarity = lacunarity
	star_noises.fractal_gain = gain
	
	star_noises2.frequency = star_noises_frequency2
	star_noises2.fractal_octaves = octaves2
	star_noises2.fractal_lacunarity = lacunarity2
	star_noises2.fractal_gain = gain2


func procedural_seed(my_seed, i, j):
	seed(((cam_x + i) * (cam_x + i) * (cam_x + i) + (cam_y + j) * (cam_y + j) + (cam_x + i) * (cam_y + j)))


func _draw():
	for i in cells_width:
		for j in cells_height:
			procedural_seed(1, i, j)
			
			tile_position = Vector2(cam_x + i + cells_offset_x, cam_y + j + cells_offset_y)
			star_name_position_hex = map_to_local( Vector2(cam_x + i + cells_offset_x, cam_y + j + cells_offset_y)) + star_name_position
			
			var star_noise = star_noises.get_noise_2d(tile_position.x, tile_position.y)
			
			name_generator_position = local_to_map(Vector2(cam_x + i, cam_y + j))
			
			draw_hex_grid()
			draw_subsector()
			draw_sector()
			subsector_name()
			
			
			if get_cell_tile_data(0, tile_position):
				draw_names()


func draw_tile():
	for i in cells_width:
		for j in cells_height:
			procedural_seed(1, i, j)
			
			tile_position = Vector2(cam_x + i + cells_offset_x, cam_y + j + cells_offset_y)
			
			var star_noise = star_noises.get_noise_2d(tile_position.x, tile_position.y)
			var star_noise2 = star_noises2.get_noise_2d(tile_position.x, tile_position.y)
			
			if floor(abs(star_noise) * 400) > star_frequence + my_rand(-random, random) and floor(abs(star_noise2) * 400) > star_frequence2 + my_rand(-random, random)  and !get_cell_tile_data(0, tile_position):
				set_cell(0, tile_position, 0, Vector2(0, 0))


func draw_names():
	var hex_name = str(generate_name())
	draw_string(font, star_name_position_hex, hex_name, HORIZONTAL_ALIGNMENT_CENTER, star_name_chars * name_width, font_size, Color.WHITE)
	draw_string_outline(font, star_name_position_hex, hex_name, HORIZONTAL_ALIGNMENT_CENTER, star_name_chars * name_width, font_size, font_border, Color.BLACK)


func draw_subsector():
	# draw subsector retangles
	if int(tile_position.x) % 8 == 0:
		draw_line(map_to_local(tile_position) + Vector2(-34, 0) * resolution,
		map_to_local(tile_position + Vector2(0, 1)) + Vector2(-34, 0) * resolution, 
		grid_color, grid_width, false)
	if int(tile_position.y) % 10 == 0 and  int(tile_position.x) % 2 == 0:
		draw_line(map_to_local(tile_position) + Vector2(0, 0),
		map_to_local(tile_position) + Vector2(150, 0)  * resolution, 
		grid_color, grid_width, false)


func subsector_name():
	if int(tile_position.x) % 8 ==0 and int(tile_position.y) % 10 ==0:
		var subsector_name = str(generate_name()).left(8)
		draw_string(font, map_to_local(tile_position) + Vector2(0, -1500), subsector_name, 
		HORIZONTAL_ALIGNMENT_CENTER, -1, 512, Color.html("#202020"))
	

func draw_sector():
	# draw subsector retangles
	if int(tile_position.x) % 32 == 0:
		draw_line(map_to_local(tile_position) + Vector2(-34, 0) * resolution,
		map_to_local(tile_position + Vector2(0, 1)) + Vector2(-34, 0) * resolution, 
		Color.html("#505050"), grid_width + 14, false)
	if int(tile_position.y) % 40 == 0 and  int(tile_position.x) % 2 == 0:
		draw_line(map_to_local(tile_position) + Vector2(0, 0),
		map_to_local(tile_position) + Vector2(150, 0)  * resolution, 
		Color.html("#505050"), grid_width + 14, false)


func draw_hex_grid():
	# Draw hex grid
	draw_line(map_to_local(tile_position) + top_left, 
	map_to_local(tile_position) + top_right, 
	grid_color, grid_width)
	
	draw_line(map_to_local(tile_position) + top_right, 
	map_to_local(tile_position) + middle_right, 
	grid_color, grid_width)
		
	draw_line(map_to_local(tile_position) + middle_right, 
	map_to_local(tile_position) + bottom_right, 
	grid_color, grid_width)


func my_rand(min, max):
	var random100: int = floor(randf_range(min, max))
	return random100


func camera_coord(cx: float, cy: float,):
	var coords = local_to_map(Vector2(cx, cy))
	cam_x = coords.x
	cam_y = coords.y


func generate_name():
	var char1 = [
	"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",
	"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",
	"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",
	"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",]
	var char2 = ["a","a","e","i","o"]
	var char3  = ["bh","br","bl","cr","ch","dr","dh","fr","fh","jh","gr","nh","mh","mr",
	"pr","ph","ps","pw","st","str","sh","sw","sp","sk","sl","ss","tr","th","wh",
	"wr","vl","vh","vr","wl","a","e","i","o","u"]
	var store_name = []
	var complete = ""
	
	# Create sylables
	for i in randf_range(1, 8):
		var space: String = ""
		var special_char: String = ""
		
		if  randf() < 0.05:
			special_char = char3.pick_random()
		else:
			special_char = char2.pick_random()
		
		if randf() < 0.05:
			store_name.push_back(" ")
		elif randf() > 0.95:
			store_name.push_back("-")
		
		store_name.push_back(char1.pick_random() + special_char + space)
	
	# create a possible number at the end of the star name
	if randf() < 0.2:
		store_name.push_back(str(floor(randf_range(1, 999))))
	
	# concatenate the sylables togheter forming a name
	for i in range(0,store_name.size()):
		complete += store_name[i] 
		
	return complete.capitalize().left(star_name_chars)


func send_map_coord():
	UI.coordinates(local_to_map(get_global_mouse_position()))
