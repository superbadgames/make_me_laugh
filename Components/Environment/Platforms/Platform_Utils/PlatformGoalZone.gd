extends Area2D

var available: bool = true

func _on_PlatformGoalZone_body_entered(body):
	if available and body.has_method("goal"):
		body.goal()
		available = false
