extends CharacterBody3D

@onready var detection_area: Area3D = $Area3D

func _ready():
	detection_area.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("joueur"):
		print("Trésor ramassé !")
		queue_free()
