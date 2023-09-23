extends Node2D

@onready var camera = $MainCamera
@onready var grid = $Grid
@onready var GenerateStars = $GenerateStars
@onready var UI = $UI
@onready var hex_grid = $HexGrid
@onready var box_x = $UI/Control/VBoxContainer/ColorRect2/Box_X
@onready var box_y = $UI/Control/VBoxContainer/ColorRect2/Box_Y

var tile_position: Vector2i

var font = load("res://monofonto rg.otf")

################################################################################
# Map resolution e tilemap cell details
################################################################################
var cells_width: int = 50
var cells_height: int = 37


var camera_pos_x: float 
var camera_pos_y: float 

var grid_refresh = true

@export var move_speed: float = 400

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

func _process(delta):
	adjust_grid_to_screen()
	move_screen(delta)
	keyboard()
#	refresh_grid()
	send_camera_position()
	release_spin_boxes()
	update_spinboxes()
	place_stars()


func place_stars():
#	GenerateStars.clear()
	for x in cells_width:
		for y in cells_height:
			procedural_seed(1, x, y)
			tile_position = Vector2(camera.position.x + x, camera.position.y + y)
			if check_hex():
				GenerateStars.set_cell(0, tile_position, 2, Vector2(0, 0))


func subsector_name(_tile_position):
	var sector_name
	if int(tile_position.x) % 8 ==0 and int(tile_position.y) % 10 ==0:
		var subsector_nam = str(generate_name(_tile_position)).left(8)
		draw_string(
			font, grid.map_to_local(tile_position) + Vector2(0, -1500), subsector_nam, 
			HORIZONTAL_ALIGNMENT_CENTER, -1, 512, Color.html("#151515"))


func procedural_seed(my_seed, i, j):
	seed(((camera_pos_x + i) * (camera_pos_x + i) * (camera_pos_x + i) + 
	(camera_pos_y + j) * (camera_pos_y + j) + (camera_pos_x + i) * (camera_pos_y + j)) + my_seed)


func check_hex():
	var star_noise = star_noises.get_noise_2d(tile_position.x, tile_position.y)
	var star_noise2 = star_noises2.get_noise_2d(tile_position.x, tile_position.y)
	if (abs(star_noise) > star_frequence + randommizing_stars(random) 
	and abs(star_noise2) > star_frequence2 + randommizing_stars(random)):
		return true
	else:
		return false


#func refresh_grid():
	############################################################################
	# Don't touch this fucking function!!!
	############################################################################
#	var GS = $GenerateStars
#	if grid_refresh == true:
#		grid_refresh = false
#		var instance = new_grid.instantiate()
#		instance.position = Vector2(-3000, -3000)
#		add_child(instance)
#		GS.name = "merda"
#		instance.name = "GenerateStars"
#		GS = $merda
#		await get_tree().create_timer(3).timeout
#		GS.queue_free()
#
#		await get_tree().create_timer(3).timeout
#		grid_refresh = true


func send_camera_position():
	grid.camera_coord(camera_pos_x, camera_pos_y)
	hex_grid.camera_coord(camera_pos_x, camera_pos_y)


func keyboard():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_filedialog_refresh"):
		get_tree().reload_current_scene()


func adjust_grid_to_screen():
	camera_pos_x = (camera.position.x - get_viewport_rect().size.x * 6) 
	camera_pos_y = (camera.position.y - get_viewport_rect().size.y * 6)  


func move_screen(delta):	
	move_speed = 400
	
	if Input.is_action_pressed("scroll_fast"):
		move_speed *= 4
	
	if Input.is_action_pressed("ui_up"):
		camera.position.y -= move_speed * delta / camera.zoom.x
	if Input.is_action_pressed("ui_down"):
		camera.position.y += move_speed * delta / camera.zoom.x
	if Input.is_action_pressed("ui_right"):
		camera.position.x += move_speed * delta / camera.zoom.x
	if Input.is_action_pressed("ui_left"):
		camera.position.x -= move_speed * delta / camera.zoom.x


func _on_box_x_value_changed(_x):
	if Input.is_action_just_pressed("ui_accept"):
		var new_value = GenerateStars.map_to_local(Vector2(_x, 0))
		camera.position.x = new_value.x


func _on_box_y_value_changed(_y):
	if Input.is_action_just_pressed("ui_accept"):
		var new_value = GenerateStars.map_to_local(Vector2(0, _y))
		camera.position.y = new_value.y


func release_spin_boxes():
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		box_y.hide()
		box_y.show()
		box_x.hide()
		box_x.show()


func update_spinboxes():
	var local_map = GenerateStars.local_to_map(camera.position)
	box_x.value = local_map.x
	box_y.value = local_map.y


func randommizing_stars(r):
	var ra = randf_range(-r, r)
	return ra


func generate_name(pos):
	var star_name_chars: int = 10
	seed(pos)
	var char1 = [
		"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",
		"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",
		"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",
		"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",]
	var char2 = [
		"a","a","e","i","o"]
	var char3  = [
		"bh","br","bl","cr","ch","dr","dh","fr","fh","jh","gr","nh","mh","mr",
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
