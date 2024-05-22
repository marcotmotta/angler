extends StaticBody3D

func _on_area_3d_2_body_entered(body):
	var collectibleComponent = body.get_node_or_null("CollectibleComponent")

	if collectibleComponent and Globals.required_items.any(func(level): return level['type'] == collectibleComponent.TYPE):
		Globals.on_item_was_dropped_in_the_hole.emit(collectibleComponent.TYPE)

func _on_area_3d_3_body_entered(body):
	if body.is_in_group("player"):
		Globals.on_player_can_blood_sacrifice.emit()
