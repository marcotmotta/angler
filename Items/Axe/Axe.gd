extends Area3D

func action():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("swing")
		$AnimationPlayer.queue("swing_back")

func _on_area_entered(area):
	if area is DestructibleComponent:
		var destructible:DestructibleComponent = area
		destructible.take_hit(50)
