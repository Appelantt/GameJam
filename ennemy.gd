extends CharacterBody3D

var player = null
var pursuit_time = 0.0
var is_pursuing = false
var is_returning_to_base = false

const SPEED = 4.0
const ATTACK_RANGE = 20
const PURSUIT_TIME_LIMIT = 20.0
const DAMAGE_COOLDOWN = 1.5

@export var player_path := "../PlayerManager/Player"
@export var gravity := 9.8
@export var base_position := Vector3.ZERO

@onready var nav_agent = $NavigationAgent3D
@onready var raycast_enemy = $RayCast3D

@export var patrol_offset := 8.0
@export var patrol_speed := 3.0
var patrol_target := Vector3.ZERO
var going_right := true

var is_jumping = false
var jump_velocity = 6.0
var stuck_timer = 0.0
var stuck_threshold = 1.0
var last_position = Vector3.ZERO
var unblock_direction = 1

var already_hit := false
var attack_timer = 0.0

func _ready():
	player = get_node_or_null(player_path)  # Utilisation de get_node_or_null pour éviter les erreurs si player est null
	if player == null:
		print("Le joueur n’a pas été trouvé. Vérifie le chemin dans l'inspecteur.")
	else:
		print("Joueur trouvé : ", player.name)

	raycast_enemy.enabled = true

	if base_position == Vector3.ZERO:
		base_position = global_transform.origin

	patrol_target = base_position + Vector3(patrol_offset, 0, 0)
	last_position = global_position

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	if raycast_enemy.is_colliding():
		var seen = raycast_enemy.get_collider()
		if seen == player:
			is_pursuing = true
			is_returning_to_base = false
			pursuit_time = 0.0
	else:
		if is_pursuing:
			pursuit_time += delta
			if pursuit_time >= PURSUIT_TIME_LIMIT:
				is_pursuing = false
				is_returning_to_base = true

	if is_pursuing:
		_pursue_player(delta)
	elif is_returning_to_base:
		_return_to_base(delta)
	else:
		_patrol(delta)

	if is_pursuing or is_returning_to_base:
		_check_if_stuck_and_jump_or_shift(delta)

	attack_timer += delta
	if player != null:  # Vérification de la validité du joueur avant d'accéder à sa position
		var distance = global_position.distance_to(player.global_position)
		if is_pursuing and is_on_floor() and distance < ATTACK_RANGE:
			if attack_timer >= DAMAGE_COOLDOWN:
				player.take_damage(25)  # Appliquer les dégâts au joueur
				print("💥 Dégâts infligés au joueur.")
				attack_timer = 0.0

	move_and_slide()

func _pursue_player(delta):
	if player != null:  # Vérification de la validité du joueur avant d'accéder à sa position
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		var horizontal_direction = Vector3(direction.x, 0, direction.z).normalized()

		velocity.x = horizontal_direction.x * SPEED
		velocity.z = horizontal_direction.z * SPEED

		var target_rotation = atan2(-horizontal_direction.x, -horizontal_direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, delta * 10.0)

func _return_to_base(delta):
	var direction = (base_position - global_transform.origin).normalized()
	var horizontal_direction = Vector3(direction.x, 0, direction.z).normalized()

	velocity.x = horizontal_direction.x * SPEED
	velocity.z = horizontal_direction.z * SPEED

	var target_rotation = atan2(-horizontal_direction.x, -horizontal_direction.z)
	rotation.y = lerp_angle(rotation.y, target_rotation, delta * 10.0)

	if global_position.distance_to(base_position) < 0.5:
		is_returning_to_base = false
		patrol_target = base_position + Vector3(patrol_offset, 0, 0)
		going_right = true

func _patrol(delta):
	var direction = (patrol_target - global_transform.origin).normalized()
	velocity.x = direction.x * patrol_speed
	velocity.z = direction.z * patrol_speed

	var target_rotation = atan2(-direction.x, -direction.z)
	rotation.y = lerp_angle(rotation.y, target_rotation, delta * 10.0)

	if global_position.distance_to(patrol_target) < 0.5:
		if going_right:
			patrol_target = base_position + Vector3(patrol_offset, 0, 0)
		else:
			patrol_target = base_position + Vector3(-patrol_offset, 0, 0)
		going_right = not going_right

func _attack_player():
	if player != null:  # Vérification de la validité du joueur avant d'accéder à sa position
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		player.hit(global_position.direction_to(player.global_position))

func _check_if_stuck_and_jump_or_shift(delta):
	var moved = Vector3(global_position.x, 0, global_position.z).distance_to(Vector3(last_position.x, 0, last_position.z))

	if !is_jumping and nav_agent.get_next_path_position() != Vector3.ZERO:
		if moved < 0.05 and is_on_floor():
			stuck_timer += delta
			if stuck_timer > stuck_threshold:
				velocity.y = jump_velocity
				velocity.x += unblock_direction * 1.0
				unblock_direction *= -1
				is_jumping = true
				stuck_timer = 0.0
		else:
			stuck_timer = 0.0

	if is_on_floor() and is_jumping:
		is_jumping = false

	last_position = global_position
