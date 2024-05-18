extends Control

var dialogue = {
	'1': 'vc é daora pacas',
	'2': 'mas vc bebeu demais noite passada e n lembra como veio parar aki!',
	'3': 'voc precisa dar um jeito de eskapar...',
	'4': 'antes q o farol te mate !!!!!!!jj',
}

var dialogue_order = ['1', '2', '3', '4']
var current_page = 0

func _ready():
	$RichTextLabel.text = dialogue[dialogue_order[current_page]]
	$RichTextLabel.set_visible_characters(0)
	$RichTextLabel.set_process_input(true)

func _input(event):
	if Input.is_action_just_pressed("e"):
		if $RichTextLabel.get_visible_characters() > $RichTextLabel.get_total_character_count():
			if current_page < dialogue_order.size() - 1:
				$RichTextLabel.set_visible_characters(0)
				current_page += 1
				$RichTextLabel.text = dialogue[dialogue_order[current_page]]

		else:
			$RichTextLabel.set_visible_characters($RichTextLabel.get_total_character_count())

func _on_timer_timeout():
	$RichTextLabel.set_visible_characters($RichTextLabel.get_visible_characters() + 1)
