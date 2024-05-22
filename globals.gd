extends Node

signal on_item_was_dropped_in_the_hole(item_type)
signal on_player_can_blood_sacrifice()

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
	],
	[
		'hmmm, mais madeira',
	]
]

var dialogue_aux = ['vtnc']

var notes = {
	'n1t1': 'hi, this is my axe',
	'n2t1': 'oh, no!'
}

var required_items = [
	{
		'type': 'wood',
		'amount': 2
	},
	{
		'type': 'oil',
		'amount': 1
	},
	{
		'type': 'boar',
		'amount': 1
	},
	{
		'type': 'blood',
		'amount': 1
	}
]
