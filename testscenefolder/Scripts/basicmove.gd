extends RigidBody2D

# Constants for Gravity Direction

const directions = {
	'DOWN' : Vector2(0, 1),
	'UP'   : Vector2(0, -1),
	'RIGHT': Vector2(1, 0),
	'LEFT' : Vector2(-1, 0)
}

const states = {
	'STANDING'    : 0,
	'JUMPING'     : 1,
	'MOVING_LEFT' : 2,
	'MOVING_RIGHT': 4
}
var player_state = 0 #Current Character state. C style bit flag

const traits = {
	'SPEED'      : 70,
	'JUMP_HEIGHT': 200
}

var self_collision
var animation_player
var sprite

var jump_timer = 0
var jumpframe

var gravity_change = false
var gravity_direction

func _ready():
	set_fixed_process(true)
	set_process_input(true)

	self_collision = get_node('player_collision_sensor')
	self_collision.add_exception(self)

	animation_player = get_node("AnimatedSprite/AnimationPlayer")
	sprite = get_node("AnimatedSprite")

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

		# Handle Gravity changes
		for key in directions.keys():
			if(event.is_action("GRAVITY_" + key) and not event.is_echo()):
				# self.set_rot(deg2rad(90))
				ChangeGravityDirection(key)

	# Handle Key Release Events
	else:
		for key in ['LEFT', 'RIGHT']:
			if(event.is_action('MOVE_' + key) and not event.is_echo()):
				player_state = states.STANDING
				animation_player.play("Robot_stand")

func _fixed_process(delta):
	if(gravity_change):
		var rotations = {
			'DOWN' : 0,
			'RIGHT': 90,
			'UP'   : 180,
			'LEFT' : 270
		}

		self.set_rot(deg2rad(rotations[gravity_direction]))
		gravity_change = false

	for key in ['MOVING_LEFT', 'MOVING_RIGHT']:
		if((player_state & states[key]) and self_collision.is_colliding()): #Not ideal piece ahead
			set_axis_velocity(Vector2(traits.SPEED * ((player_state & states[key]) - 3), 0)) #Temporary workaround for the lack of ternary operators

	if(player_state & states.JUMPING):
		if(self_collision.is_colliding()):
			if(get_tree().get_frame() - jumpframe > 10):
				player_state |= states.STANDING  #Set Standing
				player_state &= ~states.JUMPING  #Set Not Jumping
				animation_player.play("Robot_stand")

func Jump():
	set_axis_velocity(Vector2(0, -traits.JUMP_HEIGHT))
	animation_player.play("Robot_jump")
	jumpframe = get_tree().get_frame()

func ChangeGravityDirection(key):
	gravity_change = true
	gravity_direction = key

	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, directions[key]) #Change Gravity Direction
