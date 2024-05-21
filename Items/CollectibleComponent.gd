extends Area3D
class_name CollectibleComponent

# This component needs a collision shape as a child when instantiated

@export var TYPE: String

func pick_up(player: Object) -> void:
	if TYPE == 'note':
		player.show_note(get_parent().TEXT_ID)
	else:
		player.add_item(TYPE)
	get_parent().queue_free()
