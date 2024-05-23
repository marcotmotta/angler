extends Area3D

@onready var sound_handler_scene = load("res://Sounds/SoundHandler.tscn")

func action():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("swing")
		$AnimationPlayer.queue("swing_back")

func _on_area_entered(area):
	if area is DestructibleComponent:
		var destructible:DestructibleComponent = area
		var sound_handler_node = sound_handler_scene.instantiate()

		destructible.take_hit(1)
		get_tree().root.add_child(sound_handler_node)
		sound_handler_node.play_sound(0)
