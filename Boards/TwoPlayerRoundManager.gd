extends Node


onready var first_player = $Players/Player_1
onready var second_player = $Players/Player_2
onready var d6 = $D6
onready var score_value = $CanvasLayer/UI/score_value
onready var jumps_value = $CanvasLayer/UI/jumps_value
onready var game_over_screen = $CanvasLayer/GameOverScreen

var current_player_turn : int = 1
var new_round : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var val = d6.roll()
	
	if val == 1 || val == 2 || val == 3 :
		print("Player 1 wins")
		current_player_turn = 1
		first_player.start_turn(d6)
	elif val == 4 || val == 5 || val == 6 :
		print("Player 2 wins")
		current_player_turn = 2
		second_player.start_turn(d6)
		second_player.start_turn(d6)


func _process(delta):
	if new_round:
		pass
	if current_player_turn == 1:
		score_value.text = str(first_player.get_score())
		jumps_value.text = str(first_player.jumps_remaining())
		
		if first_player.has_won():
			game_over_screen.show()
			new_round = true
		
		if not first_player.is_my_turn():
			next_turn()
	elif current_player_turn == 2:
		score_value.text = str(second_player.get_score())
		jumps_value.text = str(second_player.jumps_remaining())
		
		if second_player.has_won():
			game_over_screen.show()
			new_round = true
		
		if not second_player.is_my_turn():
			next_turn()

func next_turn():
	if current_player_turn == 1:
		first_player.end_turn()
		current_player_turn = 2
		second_player.start_turn(d6)
	elif current_player_turn == 2:
		second_player.end_turn()
		current_player_turn = 1
		first_player.start_turn(d6)
