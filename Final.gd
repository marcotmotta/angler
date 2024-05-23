extends Control

func _ready():
	$Label.set_visible_characters(0)

func _on_dialog_timer_timeout():
	$Label.set_visible_characters($Label.get_visible_characters() + 1)
	if $Label.get_visible_characters() > $Label.get_total_character_count():
		$AudioStreamPlayer2.stop()

func _on_exit_timer_timeout():
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")
