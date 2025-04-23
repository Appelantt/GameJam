extends Label

var score = 0

func tresor_keep():
	score += 1
	text = "Tresor trouver: %s" % score
