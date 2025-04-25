extends CharacterBody3D

@export var speed = 14
@export var gravity := 9.8
@export var jump_force := 10.0
@export var max_hp := 100
@onready var health_bar = $HealthBar 
@onready var anim_player = $Mesh/AnimationPlayer

var hp := max_hp
var canBeControlled = false
var mouse_sensitivity = 0.003
var joystick_sensitivity = 2.5  # Joystick look speed multiplier
var yaw = 0.0
var pitch = 0.0
var pivot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	pivot = $Pivot
	yaw = rotation.y
	pitch = pivot.rotation.x

	# Met à jour la barre de vie au démarrage
	health_bar = get_node_or_null("/root/Quartier/Control/HealthBar")
	if health_bar:
		health_bar.value = hp

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))

		rotation.y = yaw
		pivot.rotation.x = pitch

func _physics_process(delta):
	if not canBeControlled:
		return

	# -- Joystick Look --
	var look_x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var look_y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")

	var deadzone = 0.1
	if abs(look_x) > deadzone or abs(look_y) > deadzone:
		yaw -= look_x * joystick_sensitivity * delta
		pitch -= look_y * joystick_sensitivity * delta
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))

		rotation.y = yaw
		pivot.rotation.x = pitch

	# -- Movement --
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force

	move_and_slide()
		# Animation logic
	if direction.length() > 0.1:
		anim_player.play("Walking in place/mixamo_com")
	else:
		anim_player.play("look around/mixamo_com")

func set_camera_visibility(isVisible):
	$Pivot/Camera3D.set_current(isVisible)

# À ajouter dans le script du joueur
var health = 100  # Vie du joueur

# Fonction pour recevoir des dégâts
func take_damage(amount):
	health -= amount
	print("Aïe ! Vie restante : ", health)
	health = max(health, 0)

	# Mise à jour de la barre de vie
	if health_bar:
		health_bar.value = health

	if health <= 0:
		print("Le joueur est mort.")
		die()

func die():
	print("💀 Le joueur est mort !")
	canBeControlled = false
	visible = false
	set_camera_visibility(false)

	var manager = get_parent()
	if manager.has_method("reset_game"):
		manager.call_deferred("reset_game")
	else:
		print("❌ Impossible d'appeler reset_game()")
