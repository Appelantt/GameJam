extends CharacterBody3D

var player = null
var pursuit_time = 0.0  # Temps pendant lequel l'ennemi poursuit le joueur
var is_pursuing = false  # Si l'ennemi est en train de poursuivre le joueur

const SPEED = 4.0
const ATTACK_RANGE = 2.0
const PURSUIT_TIME_LIMIT = 20.0  # 20 secondes de poursuite maximale

@export var player_path := "../Player"

@onready var nav_agent = $NavigationAgent3D
@onready var raycast_enemy = $RayCast3D  # Renommé ici pour éviter le conflit

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	raycast_enemy.enabled = true  # Active le raycast

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO  # Réinitialise la vitesse à chaque frame

	# Si l'ennemi voit le joueur, on lance la poursuite
	if raycast_enemy.is_colliding() and raycast_enemy.get_collider() == player:
		is_pursuing = true
		pursuit_time = 0.0  # Réinitialise le temps de poursuite
	else:
		# Si l'ennemi ne voit plus le joueur, il continue de patrouiller
		if is_pursuing:
			pursuit_time += delta
			if pursuit_time >= PURSUIT_TIME_LIMIT:
				is_pursuing = false  # Arrête la poursuite après 20 secondes

	# Si l'ennemi poursuit le joueur, on applique la poursuite
	if is_pursuing:
		_pursue_player(delta)
	else:
		_patrol(delta)  # On peut définir un comportement de patrouille ici

	# Applique le mouvement avec move_and_slide
	move_and_slide()  # Ici, on utilise velocity et on spécifie la direction "UP" pour la gravité

# Fonction pour poursuivre le joueur
func _pursue_player(delta):
	# Calcule la direction du joueur par rapport à l'ennemi
	var direction_to_player = (player.global_transform.origin - global_transform.origin).normalized()

	# Applique la direction au mouvement
	velocity = direction_to_player * SPEED

	# Rotation progressive vers la direction de déplacement
	var target_rotation = atan2(-direction_to_player.x, -direction_to_player.z)
	rotation.y = lerp_angle(rotation.y, target_rotation, delta * 10.0)  # Rotation progressive

# Fonction pour patrouiller (comportement de patrouille basique)
func _patrol(delta):
	# Ici, tu peux ajouter la logique de patrouille
	# Exemple : Patrouiller entre plusieurs points définis.
	pass

# Fonction pour attaquer le joueur
func _attack_player():
	# L'ennemi regarde le joueur pendant l'attaque
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

	# Appel de la méthode hit du joueur (selon ton script de joueur)
	player.hit(global_position.direction_to(player.global_position))  # Attaque
