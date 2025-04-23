extends CharacterBody3D

@export var speed = 14
@export var gravity := 9.8
@export var jump_force := 10.0

var hp = 100  # ❤️ Points de vie du joueur


var canBeControlled = false

func set_camera_visibility(isVisible):
	$Pivot/Camera3D.set_current(isVisible)
	
# Contrôle souris
@onready var pivot = $Pivot

var mouse_sensitivity = 0.003
var yaw = 0.0
var pitch = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var health_bar = get_node("../Control/HealthBar")
	if health_bar:
		health_bar.value = hp

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))

		# Le corps (Player) tourne sur l'axe Y (yaw)
		rotation.y = yaw

		# Le pivot (Pivot) tourne sur l'axe X (pitch)
		pivot.rotation.x = pitch

func _physics_process(delta):
	var direction = Vector3.ZERO
	if(canBeControlled):

		# Ces directions sont maintenant en fonction de la rotation du joueur
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
		
	if canBeControlled and Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()
	
	# ❤️ FONCTION pour recevoir des dégâts
func take_damage(amount):
	hp -= amount
	print("HP :", hp)

	if hp <= 0:
		die()

# 💀 FONCTION appelée à 0 HP
func die():
	print("Le joueur est mort !")
	queue_free()  # Ou respawn, animation, etc.
