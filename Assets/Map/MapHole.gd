extends Area3D

func _on_body_entered(body):
	var collectibleComponent = body.get_node_or_null("CollectibleComponent")

	if collectibleComponent and collectibleComponent.TYPE in Globals.required_items:
		Globals.on_item_was_dropped_in_the_hole.emit(collectibleComponent.TYPE)
