extends Area3D
class_name CollectibleComponent

# This component needs a collision shape as a child when instantiated

@export var TYPE: String

func pick_up(player: Object) -> void:
	if TYPE == 'note':
		player.show_note(get_parent().TEXT_ID)
		get_parent().queue_free()
	elif TYPE == 'axe':
		player.get_axe()
		get_parent().queue_free()
	elif TYPE == 'boar guts':
		player.add_item(TYPE)
		get_parent().get_node('javali-morto').get_node('porco_vivo_001').get_node('tripa').visible = false
		queue_free()
	else:
		player.add_item(TYPE)
		get_parent().queue_free()
