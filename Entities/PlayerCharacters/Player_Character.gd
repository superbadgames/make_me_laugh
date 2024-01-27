extends KinematicBody2D

const UP : Vector2 = Vector2.UP
const GRAVITY : float = 500.0
const FAIL_PLANE : float = 1000.0
# Max speed the velocity can reach from acceleration
# X values
const walk_max_speed : float = 250.0
const run_max_speed : float = 600.0
# Y value
const jump_max_speed : float = 500.0
# These are the acceleration values. These are appliec to the velocity each fram
# to move the player
# X values
const walk_accel : float = 50.0
const run_accel : float = 75.0
const air_accel : float = 15.0
# Y Values
const jump_accel : float = 150.0
# Rate of slow down, while on the ground
const ground_decel : float = 75.0 

onready var animatedSprite = $AnimatedSprite

var move_velocity : Vector2 = Vector2.ZERO
var restore_position : Vector2 = position
var can_jump : bool = true
var in_air : bool


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	move()
	jump()
	move_and_slide(move_velocity, UP)
	apply_gravity()
	check_for_fail()


# For now, I am going to hard code everything as if this is player 1. 
# Later, I will need a way to determine which player you are. 1-4
func move():
	if Input.is_action_pressed("p1_right"):
		if not in_air:
			if Input.is_action_pressed("p1_action"):
				move_velocity.x += run_accel
				if move_velocity.x >= run_max_speed: 
					move_velocity.x = run_max_speed
			else:
				move_velocity.x += walk_accel
				if move_velocity.x >= walk_max_speed:
					move_velocity.x = walk_max_speed
			animatedSprite.play("walk")
			animatedSprite.flip_h = false
		else:
			# Later, allow the player to move a little less. Create a new variable
			pass
	elif Input.is_action_pressed("p1_left"):
		if not in_air:
			if Input.is_action_pressed("p1_action"):
				move_velocity.x -= run_accel
				if move_velocity.x <= -run_max_speed: 
					move_velocity.x = -run_max_speed
			else:
				move_velocity.x -= walk_accel
				if move_velocity.x <= -walk_max_speed:
					move_velocity.x = -walk_max_speed
			animatedSprite.play("walk")
			animatedSprite.flip_h = true
	else:
		if not in_air:
			if move_velocity.x > 0:
				move_velocity.x -= ground_decel
			elif move_velocity.x < 0:
				move_velocity.x += ground_decel
			
			if move_velocity.x <= ground_decel and move_velocity.x >= -ground_decel:
				move_velocity.x = 0
				animatedSprite.play("idle")


func jump():
	if Input.is_action_pressed("p1_jump") and can_jump:
		animatedSprite.play("jump_ready")
	
	if Input.is_action_just_released("p1_jump") and can_jump:
		animatedSprite.play("jump_action")
		#move_velocity.y = -jump_power
		#can_jump = false


func apply_gravity():
	# falling, need gravity
	if not is_on_floor():
		move_velocity.y = GRAVITY
		can_jump = false
		in_air = true
	# on floor. For testing we can jump. This needs to change soon
	else:
		can_jump = true
		in_air = false


func check_for_fail():
	if position.y >= FAIL_PLANE:
		print("You kind of died! Setting position to ", restore_position)
		position = restore_position
		print("position is now ", position)


func set_restore_position(restore_pos : Vector2):
	print("restore position set to ", restore_pos)
	restore_position = restore_pos

