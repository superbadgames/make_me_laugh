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

var my_turn : bool = false
var player_string
var alive: bool = true
var move_velocity : Vector2 = Vector2.ZERO
var restore_position : Vector2 = position
var can_jump : bool = true
var jumping : bool = false
var in_air : bool
var num_jumps : int = 3


func _ready():
	print("on ready!")
	assert(PLAYER_NUMBER != 0, "ERROR! No player value set!")
	if PLAYER_NUMBER == 1:
		player_string = "p1_"
	elif PLAYER_NUMBER == 2:
		player_string = "p2_"
	elif PLAYER_NUMBER == 3 :
		player_string = "p3_"
	elif PLAYER_NUMBER == 4 :
		player_string = "p4_"


func _physics_process(delta):
	if my_turn:
		move()
		jump()
		move_and_slide(move_velocity, UP)
		apply_gravity()
		check_for_fail()


# For now, I am going to hard code everything as if this is player 1. 
# Later, I will need a way to determine which player you are. 1-4
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
	position = restore_position
	alive = true


func start_turn():
	my_turn = true


func end_turn():
	my_turn = false

# failed attempt to dynamically set the animated sprite. This is not going to work the way I had hoped.
#func load_sprite_by_character_number():
#	if CHARACTER_NUMBER == 1:
#		animatedSprite.frames = SpriteFrames.new()
#		# idle
#		var idle01: StreamTexture = load("res://Entities/PlayerCharacters/1_First/character_1_idle01.png")
#		var idle02: StreamTexture = load("res://Entities/PlayerCharacters/1_First/character_1_idle02.png")
#
#		animatedSprite.frames.add_frame("idle", idle01, 0)
#		animatedSprite.frames.add_frame("idle", idle02, 1)
#		animatedSprite.frames.set_animation_speed("idle", 0.25)
#
#		# walk
#		var walk01: StreamTexture = load("res://Entities/PlayerCharacters/1_First/character_1_walk01.png")
#		var walk02: StreamTexture = load("res://Entities/PlayerCharacters/1_First/character_1_walk02.png")
#
#		animatedSprite.frames.add_frame("walk", walk01, 0)
#		animatedSprite.frames.add_frame("walk", walk02, 1)
#
#		# jump
#		var jump: StreamTexture = load("res://Entities/PlayerCharacters/1_First/character_1_jump02.png")
#
#		animatedSprite.frames.add_frame("jump", jump, 0)
#	elif CHARACTER_NUMBER == 2:
#		animatedSprite.frames = SpriteFrames.new()
#		# idle
#		var idle01: StreamTexture = load("res://Entities/PlayerCharacters/2_Second/character_2_idle01.png")
#		var idle02: StreamTexture = load("res://Entities/PlayerCharacters/2_Second/character_2_idle02.png")
#
#		animatedSprite.frames.add_frame("idle", idle01, 0)
#		animatedSprite.frames.add_frame("idle", idle02, 1)
#		animatedSprite.frames.set_animation_speed("idle", 0.25)
#
#		# walk
#		var walk01: StreamTexture = load("res://Entities/PlayerCharacters/2_Second/character_2_walk01.png")
#		var walk02: StreamTexture = load("res://Entities/PlayerCharacters/2_Second/character_2_walk02.png")
#
#		animatedSprite.frames.add_frame("walk", walk01, 0)
#		animatedSprite.frames.add_frame("walk", walk02, 1)
#
#		# jump
#		var jump: StreamTexture = load("res://Entities/PlayerCharacters/2_Second/character_2_jump02.png")
#
#		animatedSprite.frames.add_frame("jump", jump, 0)

