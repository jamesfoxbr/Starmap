extends Node2D

@onready var camera = $MainCamera
@onready var grid = $Grid
@onready var UI = $UI
@onready var hex_grid = $HexGrid
@onready var new_grid = preload("res://scenes/generate_stars.tscn")

signal camera_position(camx, camy)

var camera_pos_x: float 
var camera_pos_y: float 

var grid_refresh = true

@export var move_speed: float = 400

@warning_ignore("unused_parameter")
func _process(delta):
	adjust_grid_to_screen()
	move_screen(delta)
	keyboard()
	refresh_grid()
	send_camera_position()
	
func refresh_grid():
	############################################################################
	# Don't touch this fucking function!!!
	############################################################################
	var GS = $GenerateStars
	if grid_refresh == true:
		grid_refresh = false
		var instance = new_grid.instantiate()
		instance.position = Vector2(-3000, -3000)
		add_child(instance)
		GS.name = "merda"
		instance.name = "GenerateStars"
		GS = $merda
		await get_tree().create_timer(3).timeout
		GS.queue_free()
		
		await get_tree().create_timer(3).timeout
		grid_refresh = true


func send_camera_position():
	var GenerateStars = $GenerateStars
	GenerateStars.camera_coord(camera_pos_x, camera_pos_y)
	grid.camera_coord(camera_pos_x, camera_pos_y)
	hex_grid.camera_coord(camera_pos_x, camera_pos_y)


func keyboard():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_filedialog_refresh"):
		get_tree().reload_current_scene()


func adjust_grid_to_screen():
	camera_pos_x = (camera.position.x - get_viewport_rect().size.x) 
	camera_pos_y = (camera.position.y - get_viewport_rect().size.y)  


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

