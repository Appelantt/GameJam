extends CharacterBody3D

@export var joueur: NodePath  # Référence du joueur dans l'éditeur
@export var vitesse: float = 5.0  # Vitesse de déplacement de l'ennemi
@export var distance_vue: float = 15.0  # Distance à laquelle l'ennemi peut voir le joueur
@export var temps_perte_vue: float = 3.0  # Temps avant d'abandonner la poursuite après avoir perdu le joueur
@export var distance_patrouille: float = 10.0  # Distance avant de changer de direction dans la patrouille

var joueur_ref: Node3D  # Référence du joueur
var poursuite = false  # État de poursuite
var derniere_position_vue = -1.0  # Dernière fois où le joueur a été vu
var direction = Vector3.FORWARD  # Direction initiale de patrouille
var last_position = Vector3.ZERO  # Dernière position enregistrée pour la patrouille

func _ready():
	joueur_ref = get_node(joueur)  # Récupère la référence du joueur
	if joueur_ref == null:
		print("Erreur : Le joueur n'a pas été assigné correctement.")
	else:
		print("Joueur trouvé : ", joueur_ref.name)

func _process(delta):
	if joueur_ref == null:
		return  # Si le joueur n'est pas assigné, on arrête le traitement
	
	var space_state = get_world_3d().direct_space_state  # Récupère l'état du monde physique
	
	# Calculer la direction vers le joueur
	var to_player = (joueur_ref.global_transform.origin - global_transform.origin).normalized()
	
	# Si la direction vers le joueur est nulle, on s'assure que cela ne pose pas de problème
	if to_player.length() == 0:
		print("Erreur : La direction vers le joueur est nulle.")
		return
	
	# Détection du joueur via un RayCast
	var raycast_vision = RayCast3D.new()
	raycast_vision.cast_to = to_player * distance_vue  # Raycast pour voir si le joueur est dans la ligne de mire
	if raycast_vision.is_colliding():
		var collider = raycast_vision.get_collider()
		if collider == joueur_ref:
			poursuite = true  # Si le joueur est vu, commencer la poursuite
			derniere_position_vue = -1.0  # Réinitialise le timer de perte de vue
		else:
			if derniere_position_vue < 0.0:
				derniere_position_vue = Time.get_ticks_msec() / 1000.0  # Début du timer de perte de vue
			poursuite = false
	else:
		if derniere_position_vue >= 0.0 and Time.get_ticks_msec() / 1000.0 - derniere_position_vue > temps_perte_vue:
			poursuite = false  # Abandonner la poursuite si trop de temps s'est écoulé

	# Si en poursuite
	var velocity = Vector3.ZERO  # Initialisation de la vitesse
	if poursuite:
		# Si en poursuite, se diriger vers le joueur
		velocity = to_player * vitesse
	else:
		# Si pas en poursuite, patrouiller
		# Si l'ennemi a parcouru une distance suffisante, il change de direction
		if global_transform.origin.distance_to(last_position) >= distance_patrouille:
			direction = -direction  # Inverser la direction
			last_position = global_transform.origin  # Réinitialiser la position de départ
		velocity = direction * vitesse  # Appliquer la vitesse pour la patrouille
	
	# Affecte la vitesse à la propriété velocity de CharacterBody3D
	self.velocity = velocity

	# Applique le mouvement avec move_and_slide sans arguments supplémentaires
	move_and_slide()
	
	# Tourne l'ennemi pour qu'il regarde le joueur (si en poursuite)
	if poursuite:
		look_at(joueur_ref.global_transform.origin, Vector3.UP)
