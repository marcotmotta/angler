extends CharacterBody3D

@onready var cutscenes_manager_scene = load("res://Cutscene/CutscenesManager.tscn")
@onready var sound_handler_scene = load("res://Sounds/SoundHandler.tscn")

@onready var axe_scene = load("res://Items/Axe/Axe.tscn")

@onready var items_scenes = {
	'wood': load("res://Items/Wood/Wood.tscn"),
	'oil barrel': load("res://Items/Oil/Oil.tscn"),
	'boar guts':  load("res://Items/BoarGuts/BoarGuts.tscn")
}

@onready var items_icons = {
	'wood': load("res://UI/WOOD.png"),
	'oil barrel': load("res://UI/OILBARREL.png"),
	'boar guts': load("res://UI/BOARGUTS.png")
}

# Movement and camera parameters
var SPEED = 1.5
var JUMP_SPEED = 7

var camera
var rotation_helper
var first_person = true

var MOUSE_SENSITIVITY = 0.04

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Health parameters
var MAX_HEALTH = 5
var health = MAX_HEALTH

# Pick up and drop logic
var aimed_object = null

# Inventory logic
var item_held = ''

# level
var current_level = 0
var can_blood_sacrifice = false

# axe
var has_axe = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Camera
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper

	# start game
	$UI/Dialog.show_next_dialog(false)
	get_parent().get_node('N1light').visible = true

	Globals.on_item_was_dropped_in_the_hole.connect(_on_item_was_dropped_in_the_hole)
	Globals.on_player_can_blood_sacrifice.connect(_on_player_can_blood_sacrifice)

func _check_pick_up_or_drop():
	var collision_object = $Rotation_Helper/PickUpRay.get_collider()

	if collision_object is CollectibleComponent:
		aimed_object = collision_object
		$UI/Control/PickUpOrDropLabel.text = 'Pick Up: ' + collision_object.TYPE.capitalize()
		$UI/Control/PickUpOrDropLabel.visible = true
		$UI/Control/PressE.visible = true
		$UI/Control/Aim.label_settings.font_color = 'ff4854'
		return

	elif collision_object and collision_object.is_in_group("hole"):
		aimed_object = collision_object
		if can_blood_sacrifice:
			$UI/Control/PickUpOrDropLabel.text = 'Give Blood'
			$UI/Control/PickUpOrDropLabel.visible = true
			$UI/Control/PressE.visible = true
			$UI/Control/Aim.label_settings.font_color = 'ff4854'
			return
		elif item_held:
			$UI/Control/PickUpOrDropLabel.text = 'Give Item: ' + item_held.capitalize()
			$UI/Control/PickUpOrDropLabel.visible = true
			$UI/Control/PressE.visible = true
			$UI/Control/Aim.label_settings.font_color = 'ff4854'
			return

	aimed_object = null
	$UI/Control/PickUpOrDropLabel.text = ''
	$UI/Control/PickUpOrDropLabel.visible = false
	$UI/Control/PressE.visible = false
	$UI/Control/Aim.label_settings.font_color = 'white'

#FIXME: this functions shouldnt be here
func check_lights():
	var lights_array = ['N1light', 'N2light', 'N3light', 'N4light']
	for i in range(lights_array.size()):
		var light = get_parent().get_node(lights_array[i])
		light.visible = (i + 1 == current_level)

func _process(delta):
	_check_pick_up_or_drop()

func _physics_process(delta):
	var camera_transform = camera.get_global_transform()

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y -= gravity * delta * 10
	elif Input.is_action_just_pressed("space"): # Jumping
			velocity.y = JUMP_SPEED

	var direction = Vector3.ZERO
	var input_dir = Input.get_vector("a", "d", "s", "w")
	direction += -camera_transform.basis.z.normalized() * input_dir.y
	direction += camera_transform.basis.x.normalized() * input_dir.x

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Rotation_Helper/CameraAnimation.play("camera_walk", 1)
		if $Walk.is_stopped():
			var sound_handler_node = sound_handler_scene.instantiate()
			get_tree().root.add_child(sound_handler_node)
			sound_handler_node.play_sound(2)
			$Walk.start()
	else:
		$Rotation_Helper/CameraAnimation.play("stop", 0.1)
		$Walk.stop()

	# Ground Velocity
	velocity.x = direction.x * SPEED * (1.5 if Input.is_action_pressed('shift') else 1)
	velocity.z = direction.z * SPEED * (1.5 if Input.is_action_pressed('shift') else 1)

	# Moving the Character
	move_and_slide()

func _input(event):
	# Mouse rotation
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot

	if Input.is_action_pressed("action1"):
		if has_axe:
			$Rotation_Helper/Marker3D/Axe.action()

	if Input.is_action_just_pressed("e"):
		if aimed_object:
			if aimed_object is CollectibleComponent:
				if item_held and aimed_object.TYPE != 'note':
					drop_item_held(get_node("Marker3D").global_position)
				aimed_object.pick_up(self)
			else:
				if can_blood_sacrifice:
					play_final_cutscene()
				else:
					drop_item_held(aimed_object.get_node("Marker3D").global_position)

func add_item(item_type):
	if not item_held:
		item_held = item_type
		$UI/Control/InventoryLabel.text = "Holding: " + item_type.capitalize()
		$UI/Control/InventorySlot/Item.texture = items_icons[item_type]

func drop_item_held(spawn_pos):
	var drop_instance = items_scenes[item_held].instantiate()

	drop_instance.position = spawn_pos
	drop_instance.rotation = Vector3(randi() * 45, randi() * 45, randi() * 45)

	get_parent().add_child(drop_instance)

	item_held = ''
	$UI/Control/InventoryLabel.text = 'No item held'
	$UI/Control/InventorySlot/Item.texture = null

func show_note(text_id):
	$UI/Note.open(text_id)

func start_dialog(is_wrong = false):
	var lighthouse_pos = get_parent().get_node('LookPos').global_position

	# look at lighthouse
	look_at(Vector3(lighthouse_pos.x, global_position.y, lighthouse_pos.z))
	$Rotation_Helper.look_at(lighthouse_pos)

	# show dialog
	$UI/Dialog.show_next_dialog(is_wrong)

func play_final_cutscene():
	var cutscenes_manager_node = cutscenes_manager_scene.instantiate()

	get_tree().root.add_child(cutscenes_manager_node)
	cutscenes_manager_node.play_cutscene(1)
	get_parent().queue_free()

func _on_area_interaction_area_entered(area):
	if area.is_in_group('start_n1'):
		current_level = min(4, current_level + 1)
		start_dialog()
		area.queue_free()

func get_axe():
	var axe_instance = axe_scene.instantiate()
	$Rotation_Helper/Marker3D.add_child(axe_instance)
	has_axe = true

func _on_damage_timeout():
	if current_level > 0:
		var light = get_parent().get_node('N' + str(current_level) + 'light')
		if (self.global_position - light.global_position).length() > light.omni_range - 2:
			health = max(0, health - 1)
			$UI/DeathUI.update_borders(health)
		else:
			health = min(MAX_HEALTH, health + 1)
			$UI/DeathUI.update_borders(health)

func _on_walk_timeout():
	var sound_handler_node = sound_handler_scene.instantiate()

	get_tree().root.add_child(sound_handler_node)
	sound_handler_node.play_sound(2)
	
func _on_item_was_dropped_in_the_hole(item_type):
	if item_type == Globals.required_items[current_level - 1]['type']:
		Globals.required_items[current_level - 1]['amount'] -= 1
		start_dialog()

		if Globals.required_items[current_level - 1]['amount'] == 0:
			current_level = min(4, current_level + 1)
			check_lights()

	else:
		start_dialog(true)

func _on_player_can_blood_sacrifice():
	if Globals.required_items[current_level - 1]['type'] == 'blood':
		can_blood_sacrifice = true
