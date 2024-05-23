extends Control

@onready var cutscenes = [
	load("res://Videos/IntroCutscene.ogv"),
	load("res://Videos/FinalCutscene.ogv")
]

var playing_cutscene = -1

func play_cutscene(cutscene_number):
	$AspectRatioContainer/VideoStreamPlayer.stream = cutscenes[cutscene_number]
	$AspectRatioContainer/VideoStreamPlayer.play()

	playing_cutscene = cutscene_number

func _on_video_stream_player_finished():
	if playing_cutscene == 0:
		get_tree().change_scene_to_file("res://Main.tscn")
	else:
		get_tree().change_scene_to_file("res://Final.tscn")
