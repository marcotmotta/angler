extends CharacterBody3D

# Movement and camera parameters
var SPEED = 3
var JUMP_SPEED = 7

var camera
var rotation_helper
var first_person = true

var MOUSE_SENSITIVITY = 0.04

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Health parameters
var MAX_HEALTH = 5
var health = MAX_HEALTH

# Pick up logic
var pick_up_object = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Camera
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper

func _check_pick_up():
	var collision_object = $Rotation_Helper/PickUpRay.get_collider()
	if collision_object is CollectibleComponent:
		pick_up_object = collision_object
		$UI/Control/PickUpLabel.text = 'Press E\nPick Up ' + collision_object.TYPE.capitalize()
		$UI/Control/PickUpLabel.visible = true
		$UI/Control/ColorRect.color = 'red'
		return

	pick_up_object = {}
	$UI/Control/PickUpLabel.text = ''
	$UI/Control/PickUpLabel.visible = false
	$UI/Control/ColorRect.color = 'white'

func _process(delta):
	_check_pick_up()

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
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

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
		if pick_up_object:
			pick_up_object.pick_up(self)

func add_item(item_type):
	match item_type:
		'note':
			$UI/Note.open('quem leu eh gay')
		'wood':
			pass

func _on_damage_timeout():
	var light = get_parent().get_node("OmniLight3D")
	if (self.global_position - light.global_position).length() > light.omni_range:
		health = max(0, health - 1)
	else:
		health = min(MAX_HEALTH, health + 1)

	print(health)
