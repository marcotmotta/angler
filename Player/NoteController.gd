extends Control

@onready var sound_handler_scene = load("res://Sounds/SoundHandler.tscn")

var is_from_pause_ui = false # if note is called from a 'world action' or the 'pauseUI menu'

func open(text_id, from_pause = false):
	var sound_handler_node = sound_handler_scene.instantiate()

	is_from_pause_ui = from_pause
	Globals.notes[text_id].taken = true
	visible = true
	$Label.text = Globals.notes[text_id].text
	$Title.text = Globals.notes[text_id].title
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().root.add_child(sound_handler_node)
	sound_handler_node.play_sound(1)
	get_tree().paused = true

func close():
	if not is_from_pause_ui:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
	$Label.text = ''

func _on_close_note_pressed():
	close()
