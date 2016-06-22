extends RigidBody2D

# Constants for Gravity Direction

class PlayerState:
	
	const move_directions = {
		'NONE' : 0,
		'LEFT' : 1,
		'RIGHT': 2
	}
	var move_dir = move_directions.NONE
	
	const jumps = {
		'NOT_JUMPING' : 0,
		'JUMPING'     : 1,
		'JUMP_ECHO'   : 2, #Wether you were jumping before
	}
	var jumping
	var jump_frame
	

const directions = {
	'DOWN' : Vector2(0, 1),
	'UP'   : Vector2(0, -1),
	'RIGHT': Vector2(1, 0),
	'LEFT' : Vector2(-1, 0)
}

var player_state #Current Character state

const traits = {
	'SPEED'      : 70,
	'JUMP_HEIGHT': 200
}

var self_collision
var animation_player
var sprite


var gravity_change = false
var gravity_direction

func _ready():
	player_state = PlayerState.new()
	gravity_direction = 'DOWN'

	set_fixed_process(true)
	set_process_input(true)

	self_collision = get_node('player_collision_sensor')
	self_collision.add_exception(self)

	animation_player = get_node("AnimatedSprite/AnimationPlayer")
	sprite = get_node("AnimatedSprite")
	
	player_state.jump_frame = get_tree().get_frame()
	animation_player.play("Robot_stand")

func _input(event):
	# Handle Keypress Events
	if(event.is_pressed()):
		for key in ['LEFT', 'RIGHT']:
			if(event.is_action('MOVE_' + key) and not event.is_echo()):
				player_state.move_dir += player_state.move_directions[key] #Avoid prefering RIGHT if both are pressed
				animation_player.play("Robot_walk")
				if(gravity_direction == 'DOWN' || gravity_direction == 'LEFT'):
					sprite.set_flip_h(key == 'LEFT')
				if(gravity_direction == 'UP' || gravity_direction == 'RIGHT'):
					sprite.set_flip_h(key != 'LEFT')

		if(event.is_action('JUMP') and not event.is_echo()):
			if(self_collision.is_colliding()):
				player_state.jumping = player_state.jumps.JUMPING

		# Handle Gravity changes
		for key in directions.keys():
			if(event.is_action("GRAVITY_" + key) and not event.is_echo()):
				ChangeGravityDirection(key)

	# Handle Key Release Events
	else:
		for key in ['LEFT', 'RIGHT']:
			if(event.is_action('MOVE_' + key) and not event.is_echo()):
				player_state.move_dir = player_state.move_directions.NONE
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

	for key in ['LEFT', 'RIGHT']:
		if((player_state.move_dir == player_state.move_directions[key]) and self_collision.is_colliding()):
			var mult = {false : -1, true : 1}
			var speed = traits.SPEED * mult[player_state.move_dir == player_state.move_directions.RIGHT] #((player_state.move_dir & player_state.move_directions[key]) - 3)
			if(gravity_direction == 'LEFT' || gravity_direction == 'RIGHT'):
				set_axis_velocity(Vector2(0, speed))
			else:
				set_axis_velocity(Vector2(speed, 0))

	if(self_collision.is_colliding()):
		if(player_state.jumping == player_state.jumps.JUMPING):
			set_axis_velocity(-(directions[gravity_direction] * traits.JUMP_HEIGHT))
			animation_player.play("Robot_jump")
			player_state.jump_frame = get_tree().get_frame()
			
			player_state.jumping = player_state.jumps.JUMP_ECHO
		if(get_tree().get_frame() - player_state.jump_frame > 20 && (player_state.jumping == player_state.jumps.JUMP_ECHO)):
			player_state.jumping = player_state.jumps.NOT_JUMPING
			
			if(player_state.move_dir == player_state.move_directions.NONE):
				animation_player.play("Robot_stand")
			elif(not player_state.move_dir == (player_state.move_directions.LEFT + player_state.move_directions.RIGHT)): #Avoid trying to walk both ways
				animation_player.play("Robot_walk")
				
	if(player_state.move_dir == (player_state.move_directions.LEFT + player_state.move_directions.RIGHT) and self_collision.is_colliding()):
		animation_player.play("Robot_stand")

func ChangeGravityDirection(key):
	gravity_change = true
	gravity_direction = key

	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, directions[key]) #Change Gravity Direction
