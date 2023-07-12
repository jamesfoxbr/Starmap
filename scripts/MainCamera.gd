extends Camera2D

@export var zoom_increment: float = 0.2
@export var zoom_current: float = 1
@export var zoom_target: float = 0.2
@export var zoom_speed: float = 5


func  _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= event.relative / zoom


func _process(delta):
	if(Input.is_action_just_released("zoom_in")):
		zoom_target = zoom_current + zoom_increment

	if(Input.is_action_just_released("zoom_out")):
		zoom_target = zoom_current - zoom_increment

	zoom_current = lerp(zoom_current, zoom_target, zoom_increment * delta * 20)

	if zoom_current < 0.1:	# control maximum zoom
		zoom_current = 0.1
	if zoom_current > 2:	# control minimum zoom
		zoom_current = 2

	set_zoom(Vector2(zoom_current, zoom_current))
