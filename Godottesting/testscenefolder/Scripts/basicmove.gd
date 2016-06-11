extends RigidBody2D

# Constants for Gravity Direction

var directions = {
	'DOWN' : Vector2(0, 1),
	'UP'   : Vector2(0, -1),
	'RIGHT': Vector2(1, 0),
	'LEFT' : Vector2(-1, 0)
}

var states = {
	'STANDING'    : 0,
	'JUMPING'     : 1,
	'MOVING_LEFT' : 2,
	'MOVING_RIGHT': 4
	
}

var self_collision
var animation_player
var sprite


var player_state = 0 # Current Character state

#const zero_vector = Vector2(0 , 0)
#var move_vector = zero_vector

#var flip = false

var jump_timer = 0;

var speed = 70
var jump_height = 200

var jumpframe

func _ready():
	#set_process(true)
	set_fixed_process(true)
	set_process_input(true)

	self_collision = get_node('player_collision_sensor')
	self_collision.add_exception(self)

	animation_player = get_node("AnimatedSprite/AnimationPlayer")
	sprite = get_node("AnimatedSprite")

	set_mode(2) # Disallow rotation on the player

	player_state = states.STANDING
	animation_player.play("Robot_stand")
	
	


func _input(event):
	# Handle Keypress Events
	if(event.is_pressed()):
		for key in ['LEFT', 'RIGHT']:
			if(event.is_action('MOVE_' + key) and not event.is_echo()):
				player_state = states['MOVING_' + key] | (player_state & states.JUMPING)
				animation_player.play("Robot_walk")
				sprite.set_flip_h(states['MOVING_' + key] & states.MOVING_LEFT != 0)

		if(event.is_action('JUMP') and not event.is_echo()):
			if(self_collision.is_colliding()):
				player_state |= states.JUMPING  #Set Jumping
				player_state &= ~states.STANDING #Set Not Standing
				Jump()

		### Handle Gravity changes
		for key in directions.keys():
			if(event.is_action("GRAVITY_" + key) and not event.is_echo()):
				ChangeGravityDirection(key)
		

	# Handle Key Release Events
	else:
		#player_state = states.STANDING
		#move_vector = zero_vector
		# Handle MOVE LEFT Event
		for key in ['LEFT', 'RIGHT']:
			if(event.is_action('MOVE_' + key) and not event.is_echo()):
				player_state = states.STANDING
				animation_player.play("Robot_stand")
		# Handle MOVE RIGHT Event
		#if(event.is_action('MOVE_RIGHT') and not event.is_echo()):
		#	player_state = states.STANDING
		#	animation_player.play("Robot_stand")



func _fixed_process(delta):
	#var x = get_pos().x
	#var y = get_pos().y

	for key in ['MOVING_LEFT', 'MOVING_RIGHT']:
		if((player_state & states[key]) and self_collision.is_colliding()):               #Not ideal piece ahead
			set_axis_velocity(Vector2(speed * ((player_state & states[key]) - 3), 0)) #Temporary workaround for the lack of ternary operators
	# move left
	#if(player_state == states.MOVING_LEFT):
	#	if(self_collision.is_colliding()):
	#		set_axis_velocity(Vector2(-speed, 0))
	#		#sprite.set_flip_h(true)

	# move right
	#if(player_state == states.MOVING_RIGHT):
	#	if(self_collision.is_colliding()):
	#		set_axis_velocity(Vector2(speed, 0))


	if(player_state & states.JUMPING):
		#print("JUMP!")
		if(self_collision.is_colliding()):
			if(get_tree().get_frame() - jumpframe > 10):
				player_state |= states.STANDING #Set Standing
				player_state &= ~states.JUMPING  #Set Not Jumping
				animation_player.play("Robot_stand")



func Jump():
	set_axis_velocity(Vector2(0, -jump_height))
	animation_player.play("Robot_jump")
	jumpframe = get_tree().get_frame()

#func Move(move_direction):
#	animation_player.play("Robot_walk")
#
#	if(move_direction == MOVING_LEFT):
#		sprite.set_flip_h(true)
#		player_state = MOVING_LEFT
#
#	if(move_direction == MOVING_RIGHT):
#		sprite.set_flip_h(false)
#		player_state = MOVING_RIGHT

func ChangeGravityDirection(key):
	var rotations = {
		'DOWN' : 0,
		'RIGHT': 90,
		'UP'   : 180,
		'LEFT' : 270
	}

	self_collision.set_rot(rotations[key])

	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, directions[key]) #Change Gravity Direction
