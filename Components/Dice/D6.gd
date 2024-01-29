extends Node2D

const min_range: int = 1
const max_range: int = 6
var random = RandomNumberGenerator.new()

onready var animation = $AnimatedSprite

func _ready():
	random.randomize()


func roll():
	var val = random.randi_range(min_range, max_range)
	print("rolled a ", val, ", gonna play that animation now")
	match val:
		1:
			animation.play("one")
		2:
			animation.play("two")
		3: 
			animation.play("three")
		4: 
			animation.play("four")
		5:
			animation.play("five")
		6:
			animation.play("six")
	return val

func toss():
	animation.play("roll")
