extends Area3D
class_name CollectibleComponent

# This component needs a collision shape as a child when instantiated

@export var TYPE: String

func pick_up(player: Object) -> void:
	player.add_item(TYPE)
	get_parent().queue_free()
