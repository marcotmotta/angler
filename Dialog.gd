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
	$RichTextLabel.text = dialog[current_line]
	$RichTextLabel.set_visible_characters(0)
	$RichTextLabel.set_process_input(true)
	current_line += 1
	is_active = true

func _input(event):
	if Input.is_action_just_pressed("e") and is_active:
		if $RichTextLabel.get_visible_characters() > $RichTextLabel.get_total_character_count():
			if current_line < dialog.size() - 1:
				$RichTextLabel.set_visible_characters(0)
				current_line += 1
				$RichTextLabel.text = dialog[current_line]
			else:
				end_dialog()

		else:
			$RichTextLabel.set_visible_characters($RichTextLabel.get_total_character_count())

func end_dialog():
	visible = false
	is_active = false
	current_line = 0
	get_tree().paused = false

func _on_timer_timeout():
	$RichTextLabel.set_visible_characters($RichTextLabel.get_visible_characters() + 1)
