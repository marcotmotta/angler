extends Control

@onready var main_scene = load("res://Main.tscn")
@onready var cutscenes = [
	load("res://Videos/IntroCutscene.ogv")
]

var playing_cutscene = -1

func _ready():
	play_cutscene(0) # FIXME: debug.

func play_cutscene(cutscene_number):
	$VideoStreamPlayer.stream = cutscenes[cutscene_number]
	$VideoStreamPlayer.play()

	playing_cutscene = cutscene_number

func _on_video_stream_player_finished():
	if playing_cutscene == 0:
		var main_node = main_scene.instantiate()

		get_tree().root.add_child(main_node)

		queue_free()
