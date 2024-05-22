extends Area3D
class_name DestructibleComponent

# This component needs a collision shape as a child when instantiated

@export var MAX_HEALTH := 100.0
var health: float

@export var drop: Resource
@export var particle: Resource

func _ready() -> void:
	randomize()
	health = MAX_HEALTH

func take_hit(amount: float) -> void:
	health -= amount
	
	if particle:
		var particle_instance = particle.instantiate()
		particle_instance.position = global_position
		get_parent().get_parent().add_child(particle_instance)

	if health <= 0:
		if drop:
			var drop_instance = drop.instantiate()
			drop_instance.position = global_position
			drop_instance.rotation = get_parent().rotation
			get_parent().get_parent().add_child(drop_instance)
		get_parent().queue_free()
