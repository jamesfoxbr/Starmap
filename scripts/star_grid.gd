extends TileMap

@export var grid_size: int = 20
@export var cells_width: int = 23
@export var cells_height: int = 10

@export var star_name_position = Vector2(-35, 40)
@export var star_name_width =  72
@export var circle_size: int = 10
var tile_position

var name_generator_position: Vector2

@onready var font = load("res://8-BIT WONDER.TTF")
@export var font_size = 8

var cam_x: int
var cam_y: int

@export var star_chance: int = 30

# draw hex grid lines variables
@export var top_left = Vector2(-24, -40)
@export var top_right = Vector2(24, -40)
@export var middle_left = Vector2(0, 0)
@export var middle_right = Vector2(48, 1)
@export var bottom_left = Vector2(-24, 40)
@export var bottom_right = Vector2(24, 43)
@export var grid_color = Color.CORNFLOWER_BLUE
@export var grid_width: int = 2

func _ready():
	await get_tree().create_timer(0.1).timeout
	clear()

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_anything_pressed():
		clear()
	queue_redraw()


func _draw():
	for i in grid_size + cells_width:
		for j in grid_size + cells_height:
			tile_position = Vector2(cam_x + i, cam_y + j)
			var name_position = map_to_local( Vector2(cam_x + i, cam_y + j)) + star_name_position
			var circle_position = map_to_local( Vector2(cam_x + i, cam_y + j))
			
			name_generator_position = local_to_map(Vector2(cam_x + i, cam_y + j))
			
			seed((cam_x + i) * (cam_x + i) * (cam_x + i) 
			+ (cam_y + j) * (cam_y + j) + (cam_x + i) * (cam_y + j))
			
			draw_grid()
			
			if rand100() < star_chance:				
				draw_string(font, name_position, 
				str(generate_name(false)), HORIZONTAL_ALIGNMENT_CENTER, 
				star_name_width, font_size)
				
				draw_circle(circle_position, circle_size, Color.WHITE)


func draw_grid():
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

func rand100():
	var random100: int = floor(randf_range(1,100))
	return random100


func camera_coord(cx: float, cy: float):
	var coords = local_to_map(Vector2(cx, cy))
	cam_x = coords.x
	cam_y = coords.y

func generate_name(random: bool):
	var char1 = ["c","d","l","m","n","p","r","s","t","h","b","f","g","j","k",
	"v","w","x","y","z","q","cr","ch","fr","gr","pr","ph","st","str","sh","sp",
	"sk","sl","tr","th","wh"]
	var char2 = ["a","a" ,"e","i","o"]
	var store_name = []
	var complete = ""
	
	if random == true:
		for i in randf_range(1, 5):
			store_name.push_back(char1.pick_random() + char2.pick_random())
	else:
		for i in randf_range(1, 5):
				store_name.push_back(char1.pick_random() + char2.pick_random())
		
	for i in range(0,store_name.size()):
		complete += store_name[i] 
		
	return complete
