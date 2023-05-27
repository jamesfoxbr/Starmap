extends SpinBox

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		hide()
		show()
