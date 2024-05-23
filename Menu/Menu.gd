extends Control

@onready var cutscenes_manager_scene = load("res://Cutscene/CutscenesManager.tscn")

func _on_play_button_pressed():
	var cutscenes_manager_node = cutscenes_manager_scene.instantiate()

	get_tree().root.add_child(cutscenes_manager_node)
	cutscenes_manager_node.play_cutscene(0)
	queue_free()

func _on_exit_button_pressed():
	get_tree().quit()
