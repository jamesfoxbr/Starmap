extends Node2D

var my_seed: float = 2			# Universe generation seed
var star_chance: int = 10		# Chance of star generation per square. Read 10 like 10% for example.

@onready var camera = $MainCamera
@onready var tilemap = $StarGrid


var camera_pos_x: float 
var camera_pos_y: float 

@export var grid_size: int = 20
@export var map_screen_align_x = -296
@export var map_screen_align_y = -398

@warning_ignore("unused_parameter")
func _process(delta):
	
	pan_screen()			# make middle mouse button pan the screen
	move_screen(delta)			# Make arrows move the screen
	generate_stars()		# Creates cells in the tilemap when it enters the map area
	delete_stars()			# Removes cells from the tilemap when it leaves the map area

	


func generate_stars():
	for i in grid_size:
		for j in grid_size:
			seed((floor(camera_pos_x + i)) * (floor(camera_pos_y + j))) # Make a fixed seed based on coordinates
			if rand100() < star_chance:									# Check for the for stars in each square
				var random_tile = randf_range(1,7)						# Chooses a random tile if a star exists
				var tile = Vector2(camera_pos_x + i, camera_pos_y + j)
				var get_tile = Vector2(random_tile,0)
				tilemap.set_cell(0, tile, 0, get_tile)
			else:
				#this is the result if there is no star and the tile choose will be empty tile.
				tilemap.set_cell(0, Vector2(camera_pos_x + i, camera_pos_y + j), 0, Vector2(7, 0))
	

func delete_stars():
	# This loop deletes de cells/tiles when it leaves the area choose in the grid_size variable (see above)	
	for i in grid_size + 5:
		for j in grid_size + 5:
			tilemap.erase_cell(0, Vector2(camera_pos_x + i - grid_size, camera_pos_y + j))
			tilemap.erase_cell(0, Vector2(camera_pos_x + i + grid_size, camera_pos_y + j))
			tilemap.erase_cell(0, Vector2(camera_pos_x + i, camera_pos_y + j - grid_size))
			tilemap.erase_cell(0, Vector2(camera_pos_x + i, camera_pos_y + j + grid_size))

func rand100():
	var random100: int = floor(randf_range(1,100))
	return random100

func pan_screen():
	# moves screen with middle mouse button
	camera_pos_x = (camera.position.x + map_screen_align_x) / 32 #This last number  is to adjust the grid with the camera position
	camera_pos_y = (camera.position.y + map_screen_align_y) / 32 #This last number  is to adjust the grid with the camera position

func move_screen(delta):
	var move_speed: float = 320
	
	if Input.is_action_pressed("scroll_fast"):
		move_speed *= 8
	
	if Input.is_action_pressed("ui_up"):
		camera.position.y -= move_speed * delta
	if Input.is_action_pressed("ui_down"):
		camera.position.y += move_speed * delta
	if Input.is_action_pressed("ui_right"):
		camera.position.x += move_speed * delta
	if Input.is_action_pressed("ui_left"):
		camera.position.x -= move_speed * delta

func star_name_generator():
	# There is a bug in some part of the code for star generation I think where soemtimes one star hae no name
	# and sometimes a empty area have a star name. This happen just sometimes is rare but annoying.
	var cell_coord = tilemap.get_cell_atlas_coords(0,Vector2(15,7))
	if cell_coord != tilemap.get_cell_atlas_coords(0,Vector2(0,7)):
		$StarGrid/Star_Names.text = "Name: " + generate_name(1, false) + " " + generate_name(2, true)
	else:
		$StarGrid/Star_Names.text = "Name: Empty Space"
	
func generate_name(this_seed, random):
	# Generate individual words to be used in the star_name_generator() or other places.
	var char1 = ["c","d","l","m","n","p","r","s","t","h","b","f","g","j","k","v","w","x","y","z","q","cr","ch","fr","gr","pr","ph","st","str","sh","sp","sk","sl","tr","th","wh"]
	var char2 = ["a","e","i","o"]
	var store_name = []
	var complete = ""
	
	if random == true:
		if rand100() < 20:
			seed(my_seed * floor(camera_pos_x) * floor(camera_pos_y) + this_seed)
			for i in randf_range(1, 4):
				store_name.push_back(char1.pick_random() + char2.pick_random())
				seed(my_seed * floor(camera_pos_x * i) * floor(camera_pos_y * i))
	else:
		for i in randf_range(1, 4):
				store_name.push_back(char1.pick_random() + char2.pick_random())
				seed(my_seed * floor(camera_pos_x * i) * floor(camera_pos_y * i))
		
	for i in range(0,store_name.size()):
		complete += store_name[i] 
		
	return complete


