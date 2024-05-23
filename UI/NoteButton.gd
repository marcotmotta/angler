extends Button

@export var from_menu = false

var text_id

func _on_pressed():
	if not from_menu:
		get_parent().get_parent().get_parent().open_note(text_id)
	else:
		get_parent().get_node('Credits').visible = not get_parent().get_node('Credits').visible
