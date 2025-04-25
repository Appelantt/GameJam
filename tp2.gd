extends Area3D

@export var teleport_position: Vector3  # 📍 Position où envoyer le joueur

# Connecte le signal dans la fonction _ready()
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Exemple de changement de position de téléportation
	teleport_position = Vector3(0, 0, 0)  # Nouvelle position de téléportation

# Lorsque le joueur entre dans la zone, on l e téléporte
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":  # Vérifie si c'est le joueur
		body.global_transform.origin = teleport_position  # Téléporte le joueur à la position définie
		print("🏠 Téléportation vers :", teleport_position)
