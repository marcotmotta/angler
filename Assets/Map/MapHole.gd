extends Area3D

func _on_body_entered(body):
	var collectibleComponent = body.get_node_or_null("CollectibleComponent")

	if collectibleComponent and Globals.required_items.any(func(level): return level['type'] == collectibleComponent.TYPE):
		Globals.on_item_was_dropped_in_the_hole.emit(collectibleComponent.TYPE)
