extends KinematicBody2D

const UP : Vector2 = Vector2.UP
const GRAVITY : float = 300.0
const JUMP_GRAVITY : float = 100.0
const TERMINAL_VELOCITY : float = 1_000.0
const FAIL_PLANE : float = 1_000.0
# Max speed the velocity can reach from acceleration
# X values
const walk_max_speed : float = 250.0
const run_max_speed : float = 600.0
const air_max_speed : float = 1_000.0
# Y value
const jump_max_speed : float = 2_000.0
# These are the acceleration values. These are appliec to the velocity each fram
# to move the player
# X values
const walk_accel : float = 50.0
const run_accel : float = 75.0
const air_accel : float = 30.0
# Y Values
const jump_accel : float = 1_000.0
const initial_jump_force : float = 500.0
# Rate of slow down, while on the ground
const ground_decel : float = 75.0 
const air_decel : float = 50.0

onready var animatedSprite = $AnimatedSprite

var move_velocity : Vector2 = Vector2.ZERO
var restore_position : Vector2 = position
var can_jump : bool = true
var jumping : bool = false
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
		elif in_air:
			move_velocity.x += air_accel
			if move_velocity.x > air_max_speed:
				move_velocity.x = air_max_speed
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
		# This did not really work like I thought it would.
		#elif in_air:
		#	move_velocity.x -= air_accel
		#	if move_velocity.x < air_max_speed:
		#		move_velocity.x = -air_max_speed
	else:
		if not in_air:
			if move_velocity.x > 0:
				move_velocity.x -= ground_decel
			elif move_velocity.x < 0:
				move_velocity.x += ground_decel
			
			if move_velocity.x <= ground_decel and move_velocity.x >= -ground_decel:
				move_velocity.x = 0
				animatedSprite.play("idle")
		elif in_air:
			if move_velocity.x > 0:
				move_velocity.x -= air_decel
			elif move_velocity.x < 0:
				move_velocity.x += air_decel
			


func jump():
	if Input.is_action_just_pressed("p1_jump"):
		if can_jump and not in_air:
			can_jump = false
			jumping = true
			move_velocity.y = -initial_jump_force
			animatedSprite.play("jump")
	elif Input.is_action_pressed("p1_jump") and jumping:
		print("about to add extra jump, move_velocity.y is", move_velocity.y)
		move_velocity.y -= jump_accel
		if move_velocity.y <= -jump_max_speed:
			jumping = false
	elif Input.is_action_just_released("p1_jump"):
		jumping = false


func apply_gravity():
	# falling, need gravity
	if not is_on_floor():
		if jumping:
			move_velocity.y += JUMP_GRAVITY
			print("gravity for jumping appliked, move_velocity y is ", move_velocity.y)
		else:
			move_velocity.y += GRAVITY
		in_air = true
		
		#if move_velocity.y > TERMINAL_VELOCITY:
		#	move_velocity.y =  TERMINAL_VELOCITY
	# on floor. For testing we can jump. This needs to change soon
	else:
		if not can_jump:
			print("hit floor, about to reset can_jump")
		can_jump = true
		in_air = false
		#move_velocity.y = 0


func check_for_fail():
	if position.y >= FAIL_PLANE:
		position = restore_position


func set_restore_position(restore_pos : Vector2):
	restore_position = restore_pos

