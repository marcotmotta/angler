extends Area3D
class_name DestructibleComponent

# This component needs a collision shape as a child when instantiated

@export var MAX_HEALTH := 100.0
var health: float

@export var drop: Resource

func _ready() -> void:
	health = MAX_HEALTH

func take_hit(amount: float) -> void:
	health -= amount

	if health <= 0:
		if drop:
			var drop_instance = drop.instantiate()
			drop_instance.global_position = global_position
			drop_instance.rotation = Vector3(randi()*30, randi()*30, randi()*30)
			get_parent().get_parent().add_child(drop_instance)
		get_parent().queue_free()
