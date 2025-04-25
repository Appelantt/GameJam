extends Node

var timer := 0.0
const QUIT_AFTER_SECONDS := 16.0

func _process(delta):
	timer += delta
	if timer >= QUIT_AFTER_SECONDS:
		print("⏰ Temps écoulé. Fermeture du jeu.")
		get_tree().quit()
