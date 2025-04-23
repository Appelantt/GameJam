extends CharacterBody3D

@onready var detection_area: Area3D = $MeshInstance3D/Area3D  # Assure-toi que ton nœud Area3D s'appelle bien "Area3D"

func _on_area_3d_body_entered(body):
	if body.name == "Player" || body.name == "spider2":  # Vérifie si le joueur touche le trésor
		print("Trésor ramassé !")
		queue_free()  # Fais disparaître le trésor
		$"../Control/Label".tresor_keep()
