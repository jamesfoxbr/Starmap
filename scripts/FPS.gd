extends Label

@warning_ignore("unused_parameter")
func _process(delta):
	text = "FPS: " + str(Engine.get_frames_per_second())
