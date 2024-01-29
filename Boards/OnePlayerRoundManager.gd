extends Node

export var max_player : int = 4
export var num_players : int = 3

onready var first_player = $Players/Player_1
onready var d6 = $D6
onready var score_value = $CanvasLayer/UI/score_value
onready var game_over_screen = $CanvasLayer/GameOverScreen

var current_player_turn : int = 1

var new_round : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	d6.roll()
	first_player.start_turn(d6)


func _process(delta):
	if new_round:
		pass
	if current_player_turn == 1:
		score_value.text = str(first_player.get_score())
		
		if first_player.has_won():
			game_over_screen.show()
			new_round = true
		
		if not first_player.is_my_turn():
			next_turn()


func next_turn():
		first_player.end_turn()
		current_player_turn = 1
		first_player.start_turn(d6)
