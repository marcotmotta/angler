extends AudioStreamPlayer

@onready var sounds = [
	load("res://Sounds/HitSound.wav"),
	load("res://Sounds/NoteSound.wav"),
	load("res://Sounds/FootstepsWalkGrassSound.wav")
]

func play_sound(sound_number):
	stream = sounds[sound_number]

	play()

func _on_finished():
	queue_free()
