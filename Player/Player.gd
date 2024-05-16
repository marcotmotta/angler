extends CharacterBody3D

# Movement and camera parameters
var SPEED = 4
var JUMP_SPEED = 7

var camera
var rotation_helper
var first_person = true

var MOUSE_SENSITIVITY = 0.04

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
		return

	pick_up_object = {}
	$UI/Control/PickUpLabel.text = ''
	$UI/Control/PickUpLabel.visible = false

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

	if Input.is_action_just_pressed("action1"):
		# FIXME: just do anything other than this. this is garbage
		$Rotation_Helper/HitArea/CollisionShape3D.disabled = false
		await get_tree().create_timer(0.5).timeout
		$Rotation_Helper/HitArea/CollisionShape3D.disabled = true

	if Input.is_action_just_pressed("e"):
		if pick_up_object:
			pick_up_object.pick_up(self)

func add_item(item):
	pass

func _on_hit_area_area_entered(area):
	if area is DestructibleComponent:
		var destructible:DestructibleComponent = area
		destructible.take_hit(30)
