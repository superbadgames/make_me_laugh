extends Area2D

onready var restore_position : Vector2

func _ready():
	restore_position = global_position
	restore_position.y -= 60 # Magic number found by testing


func _on_Area2D_body_entered(body):
	if body.has_method("set_restore_position"):
		body.set_restore_position(restore_position)
