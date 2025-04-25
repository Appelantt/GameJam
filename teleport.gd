extends Area3D

@export var teleport_position: Node3D  # 📍 Position où envoyer le joueur

# Connecte le signal dans la fonction _ready()
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

# Lorsque le joueur entre dans la zone, on l e téléporte
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":  # Vérifie si c'est le joueur
		body.global_transform.origin = teleport_position.global_position  # Téléporte le joueur à la position définie
		print("🏠 Téléportation vers :", teleport_position)
