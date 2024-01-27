extends KinematicBody2D

const UP : Vector2 = Vector2.UP
const GRAVITY : float = 2.5
const move_speed : float = 250.0
const jump_power : float = 150.0
const ledge_reset_mod : float = 1.0

onready var animatedSprite = $AnimatedSprite

var move_velocity : Vector2 = Vector2.ZERO
var can_jump : bool = true
var last_platform_position : Vector2 = position
var last_move_direction : Vector2 = move_velocity


func _ready():
	pass # Replace with function body.


func _process(delta):
	move()
	apply_gravity()


# For now, I am going to hard code everything as if this is player 1. 
# Later, I will need a way to determine which player you are. 1-4
func move():
	if Input.is_action_pressed("p1_right"):
		print("move right")
		move_velocity.x = Vector2.RIGHT.x
		animatedSprite.play("walk")
		animatedSprite.flip_h = false
		last_move_direction = move_velocity
	elif Input.is_action_pressed("p1_left"):
		print("move left")
		move_velocity.x = Vector2.LEFT.x
		animatedSprite.play("walk")
		animatedSprite.flip_h = true
		last_move_direction = move_velocity
	else:
		move_velocity.x = Vector2.ZERO.x
		animatedSprite.play("idle")
	
	if Input.is_action_pressed("p1_jump") and can_jump:
		print("jump held")
		animatedSprite.play("jump_ready")
	if Input.is_action_just_released("p1_jump") and can_jump:
		print("jump release")
		animatedSprite.play("jump_action")
		move_velocity.y = -jump_power
		can_jump = false
	
	move_and_slide(move_velocity * move_speed, UP)


func apply_gravity():
	# falling, need gravity
	if not is_on_floor():
		move_velocity.y = GRAVITY
		can_jump = false
	# on floor, maybe we jumped?
	else:
		can_jump = true
		last_platform_position = position
		


func _on_FallBorder_body_entered(body):
	can_jump = true
	print("move_velocity from _on_FallBoarder_body_entered", last_move_direction)
	position = last_platform_position
	position.x = last_move_direction.x * ledge_reset_mod
