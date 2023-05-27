extends Node2D

var map_x: int = 0			# Use this  variable to define start coordinates.
var map_y: int = 0			# Use this  variable to define start coordinates.

var my_seed: int = 2		# Universe generation seed
var move_speed: int = 1		# Map movement speed when arrows or WASD is pressed
var star_chance: int = 10	# Chance of star generation per square. Read 10 like 10% for example.

var box_x: int = 0			# Shows the current X coordinate in the X SpinBox
var box_y:int = 0			# Shows the current y coordinate in the y SpinBox

var current_x: int = 0
var current_y: int = 0
var destine_x: int = 0
var destine_y: int = 0

func  _ready():
	pass

@warning_ignore("unused_parameter")
func _process(delta):
	move_screen()
	generate_stars()
	star_name_generator()
	coordinates_controller()
	ly_calculator()

func rand100():
	var random100: int = floor(randf_range(1,100))
	return random100

func generate_stars():
	# Function to fill the screen with procedural generated tiles
	for i in 36:
		for j in 21:
			seed((floor(j + map_y)) * (floor(i + map_x)))
			if rand100() < star_chance:
				var random_tile = randf_range(1,7)
				var tile = Vector2(i, j)
				var get_tile = Vector2(random_tile,0)
				$StarGrid.set_cell(0, tile, 0, get_tile)
			else:
				$StarGrid.set_cell(0, Vector2(i,j), 0, Vector2(7, 0))

func coordinates_controller():
	# gets what someone write in the spinbox X & Y and change to this coordinate
	box_x = $StarGrid/Input_x.value
	if Input.is_action_just_pressed("ui_accept"):
		map_x = box_x 
	
	box_y = $StarGrid/Input_y.value
	if Input.is_action_just_pressed("ui_accept"):
		map_y = box_y 

func move_screen():
	# The scree is not really moving this is just a trick. The entire code just change the rpocedural tiles
	# to the side based in fake X and Y coordinates. The screen is all time static.
	if Input.is_action_pressed("scroll_fast"):
		if Input.is_action_pressed("ui_up"):
			map_y -= move_speed 
			$StarGrid/Input_y.value = map_y
		if Input.is_action_pressed("ui_down"):
			map_y += move_speed
			$StarGrid/Input_y.value = map_y
		if Input.is_action_pressed("ui_right"):
			map_x += move_speed
			$StarGrid/Input_x.value = map_x
		if Input.is_action_pressed("ui_left"):
			map_x -= move_speed
			$StarGrid/Input_x.value = map_x
	else:
		if Input.is_action_just_pressed("ui_up"):
			map_y -= move_speed
			$StarGrid/Input_y.value = map_y
		if Input.is_action_just_pressed("ui_down"):
			map_y += move_speed
			$StarGrid/Input_y.value = map_y
		if Input.is_action_just_pressed("ui_right"):
			map_x += move_speed
			$StarGrid/Input_x.value = map_x
		if Input.is_action_just_pressed("ui_left"):
			map_x -= move_speed
			$StarGrid/Input_x.value = map_x

func star_name_generator():
	# There is a bug in some part of the code for star generation I think where soemtimes one star hae no name
	# and sometimes a empty area have a star name. This happen just sometimes is rare but annoying.
	var cell_coord = $StarGrid.get_cell_atlas_coords(0,Vector2(15,7))
	if cell_coord != $StarGrid.get_cell_atlas_coords(0,Vector2(0,7)):
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
			seed(my_seed * floor(map_x) * floor(map_y) + this_seed)
			for i in randf_range(1, 4):
				store_name.push_back(char1.pick_random() + char2.pick_random())
				seed(my_seed * floor(map_x * i) * floor(map_y * i))
	else:
		for i in randf_range(1, 4):
				store_name.push_back(char1.pick_random() + char2.pick_random())
				seed(my_seed * floor(map_x * i) * floor(map_y * i))
		
	for i in range(0,store_name.size()):
		complete += store_name[i] 
		
	return complete

func ly_calculator():
	if Input.is_action_just_pressed("current"): # current is key "c" on the keyboard
		current_x = map_x
		current_y = map_y
#	if Input.is_action_just_pressed("destine"):
#		destine_x = map_x
#		destine_y = map_y
	
	var ly_distance = snapped(Vector2(current_x, current_y).distance_to(Vector2(map_x, map_y)) ,0.01)
	
	$lightyears.text = "Distance " + str(ly_distance) + " LY"
