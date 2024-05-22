extends Node

signal on_item_was_dropped_in_the_hole(item_type)

var dialogues = [
	[
		'FEED ME...',
	],
	[
		'hi, im the lighthouse-san',
		'i wan smoothies',
		'toma aki 10 reais e vai comprar uma coca zero pro pai'
	],
	[
		'hmmm madeira',
	]
]

var dialogue_aux = ['vtnc']

var notes = {
	'n1t1': 'hi, this is my axe',
	'n2t1': 'oh, no!'
}

var required_items = [
	'wood',
	'wood',
	'oil',
	'boar',
	'blood'
]

var curr_item_required = 0
