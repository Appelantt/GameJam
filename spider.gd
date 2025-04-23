extends CharacterBody3D

@export var speed := 7.0
@export var gravity := 9.8
@export var jump_force := 10.0
@export var rotation_speed := 3.0  # Vitesse de rotation

var canBeControlled = false

func set_camera_visibility(isVisible):
	$Camera3D.set_current(isVisible)

func _physics_process(delta):
	if(canBeControlled):
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
		var direction = global_transform.basis * input_vector
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		if not is_on_floor():
			velocity.y -= gravity * delta
		else:
			velocity.y = 0
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_force
			

		# Tourner vers la direction du mouvement
		if input_vector != Vector3.ZERO:
			var target_dir = direction.normalized()
			var target_rotation = atan2(-target_dir.x, -target_dir.z)  # Y rotation
			rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

		move_and_slide()
