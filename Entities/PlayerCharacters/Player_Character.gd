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
const jump_accel : float = 800.0
const initial_jump_force : float = 500.0
# Rate of slow down, while on the ground
const ground_decel : float = 75.0 
const air_decel : float = 50.0

export var PLAYER_NUMBER: int = 0

onready var animatedSprite = $AnimatedSprite
onready var respawn_timer = $RespawnTimer
onready var collision_shape = $CollisionShape2D
onready var my_camera = $Camera2D

var my_turn : bool = false
var player_string
var alive: bool = true
var move_velocity : Vector2 = Vector2.ZERO
var restore_position : Vector2 = position
var can_jump : bool = true
var jumping : bool = false
var in_air : bool
var num_jumps : int = 0
var d6
var rolled_this_turn : bool = false
var total_score : int = 0


func _ready():
	assert(PLAYER_NUMBER != 0, "ERROR! No player value set!")
	if PLAYER_NUMBER == 1:
		player_string = "p1_"
	elif PLAYER_NUMBER == 2:
		player_string = "p2_"
	elif PLAYER_NUMBER == 3 :
		player_string = "p3_"
	elif PLAYER_NUMBER == 4 :
		player_string = "p4_"
	
	assert(player_string != null && "ERROR! A Player Character has not been assigned a valid player number: ", PLAYER_NUMBER)
	visible = false
	set_physics_process(false)
	collision_shape.disabled = true

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Boards/StartScreen/StartScreen.tscn")

func _physics_process(delta):
	if my_turn:
		if not rolled_this_turn:
			d6.position = position
			d6.position.y -= 200 # Magic test number
			if Input.is_action_just_pressed(player_string + "jump"):
				jump()
				if d6 == null:
					print("you've got problems bro")
				else:
					print("Rolling! ")
					num_jumps = d6.roll()
					rolled_this_turn = true
		else:
			move()
			jump()
			move_and_slide(move_velocity, UP)
			apply_gravity()
			check_for_fail()


func move():
	if Input.is_action_pressed(player_string + "right"):
		if not in_air:
			if Input.is_action_pressed(player_string + "action"):
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
	elif Input.is_action_pressed(player_string + "left"):
		if not in_air:
			if Input.is_action_pressed(player_string + "action"):
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
				
				# Check for end turn here, so that we can keep updating after our last jump
				# TODO: Move this
				# This does seem like a strange place to put this seemingily very important
				# check, and it very much is.
				# If this check is put in the process, or at the end of this block, then
				# when the player runs out of turns, they'll stop moving mid air, and 
				# wont enter the idle state while they wait for their next turn. 
				# The real dependency here is to get the player into the idle state. 
				#
				# Consider maybe creating a function to call when num_jumps is at 0 that
				# could also set the idle state and restore the position. In fact, maybe
				# just the idle state needs to be set in the end_turn function. 
				# This is working for now. 
				if num_jumps <= 0 and rolled_this_turn:
					print("My turn is over")
					my_turn = false
					rolled_this_turn = false
		elif in_air:
			if move_velocity.x > 0:
				move_velocity.x -= air_decel
			elif move_velocity.x < 0:
				move_velocity.x += air_decel
			


func jump():
	if Input.is_action_just_pressed(player_string + "jump"):
		if can_jump and not in_air:
			can_jump = false
			jumping = true
			num_jumps -= 1
			# don't let jumps go negative
			if num_jumps < 0 : num_jumps = 0
			move_velocity.y = -initial_jump_force
			animatedSprite.play("jump")
	elif Input.is_action_pressed(player_string + "jump") and jumping:
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
		else:
			move_velocity.y += GRAVITY
		in_air = true
	# on floor. For testing we can jump. This needs to change soon
	else:
		can_jump = true
		in_air = false


func check_for_fail():
	if position.y >= FAIL_PLANE and alive:
		respawn_timer.start()
		alive = false


func set_restore_position(restore_pos : Vector2):
	restore_position = restore_pos


func _on_RespawnTimer_timeout():
	restore_position()


func start_turn(di):
	print("I got my turn, and I can roll a die now")
	d6 = di
	d6.toss()
	my_turn = true
	visible = true
	set_physics_process(true)
	collision_shape.disabled = false
	my_camera.current = true
	#alive = true


func end_turn():
	restore_position()
	set_physics_process(false)
	collision_shape.disabled = true
	#alive = false


func is_my_turn():
	return my_turn


func restore_position():
	print("restore to ", restore_position)
	position = restore_position
	alive = true

func AddScore(points : int):
	total_score += points
	print("I got a point! My score is ", total_score)


func MinusScore(points : int):
	total_score -= points
	print("I lost a point! My score is ", total_score)


func get_score():
	return total_score


func goal():
	print("You won a goal!")
