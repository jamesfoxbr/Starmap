extends Node2D

@onready var stars: PackedScene = load("res://scenes/stars.tscn")
@onready var star_grid = load("res://scenes/star_grid.tscn")
@onready var camera = $MainCamera

signal camera_position(camx, camy)

var UI = load("res://scenes/ui.tscn")

var camera_pos_x: float 
var camera_pos_y: float 

var grid_refresh = false

@export var map_screen_align_x: int = -580
@export var map_screen_align_y: int = -385

@warning_ignore("unused_parameter")
func _process(delta):
#	grid()
	pan_screen()			# make middle mouse button pan the screen
	move_screen()			# Make arrows move the screen
	keyboard()				# Keybord commands like exit game on Esc
	
	var cur_grid = $StarGrid
	cur_grid.camera_coord(camera_pos_x, camera_pos_y)


func grid():
	if grid_refresh == true:
		get_node("StarGrid").free()
		var grid_instance = star_grid.instantiate()
		grid_instance.position = Vector2(0, 0)
		add_child(grid_instance)
		grid_instance.camera_coord(camera_pos_x, camera_pos_y)
		grid_refresh = false
		
	if grid_refresh == false:
		await get_tree().create_timer(2).timeout
		grid_refresh = true


func keyboard():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func pan_screen():
	# moves screen with middle mouse button
	camera_pos_x = (camera.position.x + map_screen_align_x) / 24 #This last number  is to adjust the grid with the camera position
	camera_pos_y = (camera.position.y + map_screen_align_y) / 28 #This last number  is to adjust the grid with the camera position


func move_screen():
	var move_speed: float = 4
	
	if Input.is_action_pressed("scroll_fast"):
		move_speed *= 4
	
	if Input.is_action_pressed("ui_up"):
		camera.position.y -= move_speed
	if Input.is_action_pressed("ui_down"):
		camera.position.y += move_speed
	if Input.is_action_pressed("ui_right"):
		camera.position.x += move_speed
	if Input.is_action_pressed("ui_left"):
		camera.position.x -= move_speed


func _on_timer_refresh_timeout():
	var grid_instance = star_grid.instantiate()
	grid_instance.global_position = Vector2i(0, 0)
	add_child(grid_instance)
	grid_instance.camera_coord(camera_pos_x, camera_pos_y)
	await get_tree().create_timer(0.1).timeout
	get_node("StarGrid").free()
	grid_instance.name = "StarGrid"
	
