extends Button

var text_id

func _on_pressed():
	get_parent().get_parent().get_parent().open_note(text_id)
