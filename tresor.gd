extends CharacterBody3D

@onready var detection_area: Area3D = $MeshInstance3D/Area3D

func _on_area_3d_body_entered(body):
	if body.name == "Player" or body.name == "spider2":
		print("Trésor ramassé !")
		queue_free()
		
		var label = get_node_or_null("/root/Quartier/Control/Label")
		if label:
			label.tresor_keep()
		else:
			print("Label introuvable !")
