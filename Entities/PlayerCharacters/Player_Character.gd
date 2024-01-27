extends KinematicBody2D

const UP : Vector2 = Vector2.UP
const GRAVITY : float = 2.5
const FAIL_PLANE : float = 1000.0
const move_speed : float = 250.0
const jump_power : float = 50.0


onready var animatedSprite = $AnimatedSprite

var move_velocity : Vector2 = Vector2.ZERO
var restore_position : Vector2 = position
var can_jump : bool = true


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	move()
	apply_gravity()
	check_for_fail()


# For now, I am going to hard code everything as if this is player 1. 
# Later, I will need a way to determine which player you are. 1-4
func move():
	if Input.is_action_pressed("p1_right"):
		move_velocity.x = Vector2.RIGHT.x
		animatedSprite.play("walk")
		animatedSprite.flip_h = false
	elif Input.is_action_pressed("p1_left"):
		move_velocity.x = Vector2.LEFT.x
		animatedSprite.play("walk")
		animatedSprite.flip_h = true
	else:
		move_velocity.x = Vector2.ZERO.x
		animatedSprite.play("idle")
	
	if Input.is_action_pressed("p1_jump") and can_jump:
		animatedSprite.play("jump_ready")
	
	if Input.is_action_just_released("p1_jump") and can_jump:
		animatedSprite.play("jump_action")
		move_velocity.y = -jump_power
		can_jump = false
	
	move_and_slide(move_velocity * move_speed, UP)


func apply_gravity():
	# falling, need gravity
	if not is_on_floor():
		move_velocity.y = GRAVITY
		can_jump = false
	# on floor. For testing we can jump. This needs to change soon
	else:
		can_jump = true


func check_for_fail():
	if position.y >= FAIL_PLANE:
		print("You kind of died! Setting position to ", restore_position)
		position = restore_position
		print("position is now ", position)


func set_restore_position(restore_pos : Vector2):
	print("restore position set to ", restore_pos)
	restore_position = restore_pos
