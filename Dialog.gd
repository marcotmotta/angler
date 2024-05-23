extends Control

var current_dialog = 0
var current_line = 0

var dialog

var is_active = false

func show_next_dialog(is_wrong = false):
	get_tree().paused = true
	visible = true
	if is_wrong:
		dialog = Globals.dialogue_aux
	elif current_dialog < Globals.dialogues.size():
		dialog = Globals.dialogues[current_dialog]
		current_dialog += 1
	else:
		end_dialog()
		return
	$Label.text = dialog[current_line]
	$Label.set_visible_characters(0)
	$Label.set_process_input(true)
	is_active = true
	$AudioStreamPlayer1.play()
	$AudioStreamPlayer2.play()

func _input(event):
	if Input.is_action_just_pressed("e") and is_active:
		if $Label.get_visible_characters() > $Label.get_total_character_count():
			if current_line < dialog.size() - 1:
				$Label.set_visible_characters(0)
				current_line += 1
				$Label.text = dialog[current_line]
			else:
				end_dialog()
			$AudioStreamPlayer2.play()
		else:
			$Label.set_visible_characters($Label.get_total_character_count())

func end_dialog():
	visible = false
	is_active = false
	current_line = 0
	get_tree().paused = false
	if current_dialog == 1:
		$Background.visible = false
	$AudioStreamPlayer1.stop()

func _on_timer_timeout():
	$Label.set_visible_characters($Label.get_visible_characters() + 1)
	if $Label.get_visible_characters() > $Label.get_total_character_count():
		$AudioStreamPlayer2.stop()
