extends Node

signal on_item_was_dropped_in_the_hole(item_type)
signal on_player_can_blood_sacrifice()

var dialogues = [
	[ # start
		'The Lighthouse:\n\nFEEED MEEEE',
	],
	[ # approach
		'The Lighthouse:\n\nDARK IS DANGEEER…',
		'The Lighthouse:\n\nI GIVE YOU LIGHT…',
		'The Lighthouse:\n\nFEEEED MEEEEEE'
	],
	[ # give 1 wood
		'The Lighthouse:\n\nFEED ME MOOOORE',
	],
	[ # give 2 wood
		'*** You notice the lighthouse`s fire radiating stronger ***',
		'The Lighthouse:\n\nIT’S NOT ENOUGH! MOOOORE',
	],
	[ # give oil
		'*** You notice the light increasing even more ***',
		'The Lighthouse:\n\nUUUUUUUUUH, YEEEESS! MOOOOOORE!',
	],
	[ # give boar
		'*** You feel the ground shaking and the light becoming stronger ***',
		'The Lighthouse:\n\nAAAAAH… ALMOST THERE! BRING MORE! MORE LIGHT!',
	],
]

var dialogue_aux = ['The Lighthouse:\n\nNOOOO… NOT THIS…']

var notes = {
	'n1': {
		'title': 'Note 1 - Feed the lighthouse on the hole',
		'text': 'This strange lighthouse\nkeeps asking for food.\nThis is fascinating\nthe same as much strange.\nAnd this role, it’s\ncalling for something…',
		'taken': false
	},
	'n2': {
		'title': 'Note 2 - Signs of previous human stay',
		'text': 'This story is\nolder than it looks.\nThis lighthouse \nbeen here for centuries,\nother people lived\nhere in some way we don`t\nunderstand totally. That\nold shack holds some secret.',
		'taken': false
	},
	'n3': {
		'title': 'Note 3 - Stinky barrel',
		'text': 'Oh, by the crown,\nhow this barrel\nstinks… What the hell\ndid they use to make\nthis? Well, I\nhope it catches fire.',
		'taken': false
	},
	'n4': {
		'title': 'Note 4 - Dark madness',
		'text': 'What a disgrace, to hell\nthe moment I decide to\ncome on this trip.\nThis darkness is not normal…\nAustin is getting mad\nand I can trust him\nas much as I could trust\na dutch friendly galleon!',
		'taken': false
	},
	'n5': {
		'title': 'Note 5 - A furious boar',
		'text': 'Darn!! This place…\nBesides my crazy mate,\nthere is this bloodthirsty\nanimal. I saw a boar before,\nbut this one\nalmost killed me.\nNow I’m stuck in the tree…\nI’ll wait until h_________',
		'taken': false
	},
	'n6': {
		'title': 'Note 6 - Meat for the monster',
		'text': 'This strange sound…\nThere is wild animals\nhere? What else hides in\nthis evil darkness?\nMaybe we can hunt it\nto give to the lighthouse,\nright?',
		'taken': false
	},
	'n7': {
		'title': 'Note 7 - Early assessments',
		'text': 'Sorry my mother.\nFrom what I see from\nthis Island, our chances\nare low. Maybe our\nchances to survive is\nkilling and eating each\nother, maybe one of\nus survives.',
		'taken': false
	},
	'n8': {
		'title': "Note 8 - It's alive!",
		'text': '“It’s not enough” …\nIt keeps saying it\nand now I understand.\nIt’s not fire or some kind\nof mechanism that\nuses fuel. No,\nit’s alive and is\nvery hungry.',
		'taken': false
	}
}

var required_items = [
	{
		'type': 'wood',
		'amount': 2
	},
	{
		'type': 'oil barrel',
		'amount': 1
	},
	{
		'type': 'boar guts',
		'amount': 1
	},
	{
		'type': 'blood',
		'amount': 1
	}
]
