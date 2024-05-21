extends CharacterBody3D

@onready var wood_scene = load("res://Items/Wood/Wood.tscn")
@onready var oil_scene = load("res://Items/Oil/Oil.tscn")

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
var current_level = 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Camera
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper

func _check_pick_up_or_drop():
	var collision_object = $Rotation_Helper/PickUpRay.get_collider()
	
	if collision_object is CollectibleComponent:
		aimed_object = collision_object
		
		$UI/Control/PickUpOrDropLabel.text = 'Press E\nPick Up ' + collision_object.TYPE.capitalize()
		$UI/Control/PickUpOrDropLabel.visible = true
		$UI/Control/ColorRect.color = 'red'
		
		return
		
	elif collision_object and collision_object.is_in_group("hole") and item_held:
		aimed_object = collision_object
		
		$UI/Control/PickUpOrDropLabel.text = 'Press E\nDrop ' + item_held.capitalize()
		$UI/Control/PickUpOrDropLabel.visible = true
		$UI/Control/ColorRect.color = 'red'
		
		return

	aimed_object = null
	
	$UI/Control/PickUpOrDropLabel.text = ''
	$UI/Control/PickUpOrDropLabel.visible = false
	$UI/Control/ColorRect.color = 'white'

#FIXME: this functions shouldnt be here
func check_lights():
	var lights_array = ['N1light', 'N2light', 'N3light', 'N4light']
	for i in range(lights_array.size()):
		var light = get_parent().get_node(lights_array[i])
		light.visible = (i+1 == current_level)

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
	else:
		$Rotation_Helper/CameraAnimation.play("stop", 0.1)

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

	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("esc"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Third person FIXME: debug purposes. there wont be third person in the game
	if Input.is_action_just_pressed("f5"):
		if first_person:
			camera.position.y = 3
			camera.position.z = 4
			camera.rotation_degrees.x = -35
			first_person = false
		else:
			camera.position.y = 0.6
			camera.position.z = -0.3
			camera.rotation_degrees.x = 0
			first_person = true

	if Input.is_action_pressed("action1"):
		$Rotation_Helper/Marker3D/Axe.action()

	if Input.is_action_just_pressed("e"):
		if aimed_object:
			if aimed_object is CollectibleComponent:
				if item_held and aimed_object.TYPE != 'note':
					drop_item_held(get_node("Marker3D").global_position)
				aimed_object.pick_up(self)
			else:
				drop_item_held(aimed_object.get_node("Marker3D").global_position)

	if Input.is_action_just_pressed("f1"):
		current_level = min(4, current_level + 1)
		check_lights()

func add_item(item_type):
	if not item_held:
		item_held = item_type
		$UI/Control/InventoryLabel.text = "Holding: " + item_type.capitalize()

func drop_item_held(spawn_pos):
	var drop_instance = null
	
	match item_held:
		'wood':
			drop_instance = wood_scene.instantiate()
		'oil':
			drop_instance = oil_scene.instantiate()
	
	if drop_instance:
		drop_instance.position = spawn_pos
		drop_instance.rotation = Vector3(randi() * 45, randi() * 45, randi() * 45)
		
		get_parent().add_child(drop_instance)
		
		item_held = ''
		$UI/Control/InventoryLabel.text = 'No item held'

func show_note(text_id):
	$UI/Note.open(Globals.notes[text_id])

func _on_damage_timeout():
	var light = get_parent().get_node('N' + str(current_level) + 'light')
	if (self.global_position - light.global_position).length() > light.omni_range:
		health = max(0, health - 1)
	else:
		health = min(MAX_HEALTH, health + 1)

	print(health)
