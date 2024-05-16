extends StaticBody3D

var health = 100

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
