extends CharacterBody3D

@onready var detection_area: Area3D = $Area3D  # Assure-toi que ce noeud s'appelle bien "Area3D"

func _ready():
	if detection_area:
		detection_area.connect("body_entered", Callable(self, "_on_body_entered"))
	else:
		print("⚠️ Zone de détection non trouvée ! Vérifie que tu as bien un noeud 'Area3D'")

func _on_body_entered(body):
	if body.is_in_group("joueur"):
		print("Trésor ramassé !")
		queue_free()  # Le trésor disparaît


func _on_area_3d_body_entered(body):
	if body.is_in_group("joueur"):
		print("Trésor ramassé !")
		queue_free()
