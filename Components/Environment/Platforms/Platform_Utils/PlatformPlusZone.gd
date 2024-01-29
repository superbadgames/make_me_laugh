extends Area2D

export var points : int = 1

var player1_has_scored : bool = false
var player2_has_scored : bool = false
var player3_has_scored : bool = false
var player4_has_scored : bool = false

func _on_Plus_Score_Zone_body_entered(body):
	if body.has_method("AddScore"):
		if body.name == "Player_1" and not player1_has_scored:
			body.AddScore(points)
			player1_has_scored = true
		elif body.name == "Player_2" and not player2_has_scored:
			body.AddScore(points)
			player2_has_scored = true
		elif body.name == "Player_3" and not player3_has_scored:
			body.AddScore(points)
			player3_has_scored = true
		elif body.name == "Player_4" and not player4_has_scored:
			body.AddScore(points)
			player4_has_scored = true
