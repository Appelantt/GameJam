extends CharacterBody3D

@export var joueur: NodePath
@export var vitesse: float = 2.0
@export var distance_vue: float = 10.0

var joueur_ref: Node3D
var poursuite = false

func _ready():
	joueur_ref = get_node(joueur)

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	poursuite = false

	# DIRECTION ACTUELLE = là où il regarde
	var direction = -global_transform.basis.z.normalized()

	# DÉTECTION JOUEUR
	if joueur_ref:
		var to_joueur = (joueur_ref.global_transform.origin - global_transform.origin).normalized()
		var raycast_target = global_transform.origin + to_joueur * distance_vue
		var params = PhysicsRayQueryParameters3D.create(global_transform.origin, raycast_target)
		params.exclude = [self]

		var result = space_state.intersect_ray(params)
		if result and result.collider == joueur_ref:
			poursuite = true
			look_at(joueur_ref.global_transform.origin, Vector3.UP)
			direction = -global_transform.basis.z.normalized()

	# PATROUILLE AUTONOME
	if not poursuite:
		# Raycast sol + mur
		var pos = global_transform.origin
		var forward = pos + direction * 1.5
		var down = forward + Vector3.DOWN * 2

		var sol_check = PhysicsRayQueryParameters3D.create(forward, down)
		sol_check.exclude = [self]
		var sol = space_state.intersect_ray(sol_check)

		var wall_check = PhysicsRayQueryParameters3D.create(pos, pos + direction * 1.2)
		wall_check.exclude = [self]
		var mur = space_state.intersect_ray(wall_check)

		if not sol or not sol.collider or mur:
			# Rotate 180° sur l’axe Y
			rotate_y(PI)

	# Vitesse dans la direction actuelle
	velocity = -global_transform.basis.z.normalized() * vitesse
	move_and_slide()
