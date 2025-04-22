extends CharacterBody3D

@export var speed := 7.0
@export var gravity := 9.8
@export var jump_force := 10.0

func _physics_process(delta):
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


		

	move_and_slide()
