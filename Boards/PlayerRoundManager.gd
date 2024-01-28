extends Node

export var num_player : int = 4

onready var first_player = $Players/First_Character
onready var second_player = $Players/Second_Character
onready var third_player = $Players/Fourth_Character

var current_player_turn : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if current_player_turn == 1:
			first_player.start_turn()
			second_player.end_turn()
			third_player.end_turn()
			current_player_turn = 2
		elif current_player_turn == 2:
			first_player.end_turn()
			second_player.start_turn()
			third_player.end_turn()
			current_player_turn = 3
		elif current_player_turn == 3:
			first_player.end_turn()
			second_player.end_turn()
			third_player.start_turn()
			current_player_turn = 1
