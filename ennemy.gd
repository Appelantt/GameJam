extends CharacterBody3D

@export var joueur: NodePath
@export var vitesse: float = 2.0
@export var distance_vue: float = 10.0
@export var direction_initiale: Vector3 = Vector3.FORWARD

var joueur_ref: Node3D
var poursuite = false
var direction = Vector3.ZERO

func _ready():
	joueur_ref = get_node(joueur)
	direction = direction_initiale.normalized()

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	poursuite = false

	# DÉTECTION JOUEUR
	if joueur_ref:
		var to_joueur = (joueur_ref.global_transform.origin - global_transform.origin).normalized()
		var raycast_target = global_transform.origin + to_joueur * distance_vue
		var params = PhysicsRayQueryParameters3D.create(global_transform.origin, raycast_target)
		params.exclude = [self]

		var result = space_state.intersect_ray(params)
		if result and result.collider == joueur_ref:
			poursuite = true
			direction = to_joueur

	# PATROUILLE AUTONOME
	if not poursuite:
		var pos = global_transform.origin

		# 1. Check sol devant
		var forward = pos + direction * 1.5
		var down = forward + Vector3.DOWN * 2
		var sol_check = PhysicsRayQueryParameters3D.create(forward, down)
		sol_check.exclude = [self]

		var sol = space_state.intersect_ray(sol_check)

		# 2. Check mur devant
		var front_check = PhysicsRayQueryParameters3D.create(pos, pos + direction * 1.2)
		front_check.exclude = [self]

		var mur = space_state.intersect_ray(front_check)

		if not sol or not sol.collider or mur:
			# Pas de sol ou mur → demi-tour
			direction = -direction

	velocity = direction.normalized() * vitesse
	move_and_slide()
