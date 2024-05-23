extends Control

var note_button_scene = preload("res://UI/NoteButton.tscn")

var paused_by_ui = false

func _input(event):
	if Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("tab"):
		if not get_tree().paused:
			pause_game()
			paused_by_ui = true
		elif paused_by_ui:
			unpause_game()

func pause_game():
	paused_by_ui = true
	get_tree().paused = true
	self.visible = true
	# delete existing note buttons
	for child in $CenterContainer/Notes.get_children():
		child.queue_free()
	# add new note buttons
	for text_id in Globals.notes.keys():
		var note_button_instance = note_button_scene.instantiate()
		note_button_instance.text_id = text_id
		note_button_instance.text = Globals.notes[text_id].title if Globals.notes[text_id].taken else '?????'
		note_button_instance.disabled = not Globals.notes[text_id].taken
		$CenterContainer/Notes.add_child(note_button_instance)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func unpause_game():
	paused_by_ui = false
	get_tree().paused = false
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_continue_pressed():
	unpause_game()

func _on_exit_pressed():
	paused_by_ui = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")

func open_note(text_id):
	$"../Note".open(text_id, true)
