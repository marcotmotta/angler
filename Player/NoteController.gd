extends Control

func open(text):
	visible = true
	$Label.text = text
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func close():
	get_tree().paused = false
	visible = false
	$Label.text = ''
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_close_note_pressed():
	close()
