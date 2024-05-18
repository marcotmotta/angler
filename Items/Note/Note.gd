extends SoftBody3D

@export var TEXT_ID: String

func _process(delta):
	$CollectibleComponent.global_position = get_point_transform(64)
