extends CharacterBody3D

@export var speed := 7.0
@export var gravity := 9.8
@export var jump_force := 10.0
@export var rotation_speed := 3.0

var canBeControlled = false

# Souris + Caméra
@onready var pivot = $Pivot
var mouse_sensitivity = 0.003
var yaw = 0.0
var pitch = 0.0

func set_camera_visibility(isVisible):
	$Pivot/Camera3D.set_current(isVisible)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if canBeControlled and event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))

		rotation.y = yaw
		pivot.rotation.x = pitch

func _physics_process(delta):
	if canBeControlled:
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

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_force

		move_and_slide()
