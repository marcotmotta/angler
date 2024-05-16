extends Area3D
class_name DestructibleComponent

# This component needs a collision shape as a child when instantiated

@export var MAX_HEALTH := 100.0
var health: float

func _ready() -> void:
	health = MAX_HEALTH

func take_hit(amount: float) -> void:
	health -= amount

	if health <= 0:
		get_parent().queue_free()
