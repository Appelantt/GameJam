extends Label

var score = 0
const TOTAL_TREASURES = 8

func tresor_keep():
	score += 1
	text = "Trésor trouvé : %s" % score
	
	if score >= TOTAL_TREASURES:
		get_tree().change_scene_to_file("res://cinematique.tscn")  # Mets le bon chemin ici
