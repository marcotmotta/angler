extends Control

func update_borders(health):
	var offset = (5 - health) * 0.05
	$TextureRect.texture.gradient.offsets[1] = 0 + offset
	$TextureRect.texture.gradient.offsets[2] = 1 - offset

	if health <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		$Background.visible = true
		$Exit.visible = true
		$YouDied.visible = true

func _on_exit_pressed():
	get_tree().paused = false
	$Background.visible = false
	$Exit.visible = false
	$YouDied.visible = false
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")
