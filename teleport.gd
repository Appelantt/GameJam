extends Area3D

@export var teleport_position: Vector3  # 📍 Position où envoyer le joueur

func _on_body_entered(body):
	if body.name == "Player":
		body.global_transform.origin = teleport_position
		print("🏠 Téléportation vers la position de base :", teleport_position)
