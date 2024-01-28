extends Node

export var max_player : int = 4
export var num_players : int = 3

onready var first_player = $Players/First_Character
onready var second_player = $Players/Second_Character
onready var third_player = $Players/Fourth_Character

var current_player_turn : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	first_player.start_turn()


func _process(delta):
	if Input.is_action_just_pressed("next_turn"):
		if current_player_turn == 1:
			first_player.end_turn()
			current_player_turn = 2
			second_player.start_turn()
		elif current_player_turn == 2:
			second_player.end_turn()
			current_player_turn = 3
			third_player.start_turn()
		elif current_player_turn == 3:
			third_player.end_turn()
			current_player_turn = 1
			first_player.start_turn()
