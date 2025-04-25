extends CharacterBody3D

@export var speed := 7.0
@export var gravity := 9.8
@export var jump_force := 15
@export var rotation_speed := 3.0

@onready var pivot = $Pivot
@onready var jump_sound = $JumpSound

var canBeControlled = false
var mouse_sensitivity = 0.003
var joystick_sensitivity = 2.5
var yaw = 0.0
var pitch = 0.0

func set_camera_visibility(isVisible):
	$Pivot/Camera3D.set_current(isVisible)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yaw = rotation.y
	pitch = pivot.rotation.x

func _input(event):
	if canBeControlled and event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))

		rotation.y = yaw
		pivot.rotation.x = pitch

func _physics_process(delta):
	if not canBeControlled:
		return

	# Joystick Look
	var look_x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var look_y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	var deadzone = 0.1

	if abs(look_x) > deadzone or abs(look_y) > deadzone:
		yaw -= look_x * joystick_sensitivity * delta
		pitch -= look_y * joystick_sensitivity * delta
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))

		rotation.y = yaw
		pivot.rotation.x = pitch

	# Movement
	var input_vector = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		input_vector.z -= 1
	if Input.is_action_pressed("move_back"):
		input_vector.z += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1

	input_vector = input_vector.normalized()
	var direction = transform.basis * input_vector

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
			jump_sound.play()

	move_and_slide()
