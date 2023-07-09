extends Node2D

@onready var stars: PackedScene = load("res://scenes/stars.tscn")
@onready var star_grid = load("res://scenes/star_grid.tscn")
@onready var camera = $MainCamera
@onready var stargrid = $StarGrid
@onready var UI = $UI

signal camera_position(camx, camy)

var camera_pos_x: float 
var camera_pos_y: float 

var grid_refresh = false

@warning_ignore("unused_parameter")
func _process(delta):
	adjust_grid_to_screen()
	move_screen()
	keyboard()
	send_camera_position()


func send_camera_position():
	stargrid.camera_coord(camera_pos_x, camera_pos_y)
	UI.coordinates(camera_pos_x, camera_pos_y)


func keyboard():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func adjust_grid_to_screen():
	camera_pos_x = (camera.position.x - get_viewport_rect().size.x) 
	camera_pos_y = (camera.position.y - get_viewport_rect().size.y)  


func move_screen():
	var move_speed: float = 4
	
	if Input.is_action_pressed("scroll_fast"):
		move_speed *= 8
	
	if Input.is_action_pressed("ui_up"):
		camera.position.y -= move_speed
	if Input.is_action_pressed("ui_down"):
		camera.position.y += move_speed
	if Input.is_action_pressed("ui_right"):
		camera.position.x += move_speed
	if Input.is_action_pressed("ui_left"):
		camera.position.x -= move_speed

