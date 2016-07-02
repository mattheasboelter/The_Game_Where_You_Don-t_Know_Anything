extends RigidBody2D

# Constants for Gravity Direction

var PlayerState = preload("PlayerState.gd")

var player_state #Current Character state
var self_collision
var animation_player
var sprite

const traits = {
	'SPEED'      : 70,
	'JUMP_HEIGHT': 200
}

func _ready():
	player_state = PlayerState.new()
	#gravity_direction = 'DOWN'

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
				player_state.move.set_inc(player_state.move_directions[key]) #Avoid prefering RIGHT if both are pressed
				animation_player.play("Robot_walk")
				if(player_state.gravity.is(['DOWN', 'LEFT'])):
					sprite.set_flip_h(key == 'LEFT')
				if(player_state.gravity.is(['UP', 'RIGHT'])):
					sprite.set_flip_h(key != 'LEFT')

		if(event.is_action('JUMP') and not event.is_echo()):
			if(self_collision.is_colliding()):
				player_state.jump.set(player_state.jumps.JUMPING)

		# Handle Gravity changes
		for key in player_state.gravity_directions.keys():
			if(event.is_action("GRAVITY_" + key) and not event.is_echo()):
				player_state.gravity.set(player_state.gravity_directions[key])

	# Handle Key Release Events
	else:
		for key in ['LEFT', 'RIGHT']:
			if(event.is_action('MOVE_' + key) and not event.is_echo()):
				player_state.reset()
				animation_player.play("Robot_stand")

func _fixed_process(delta):
	player_state.update()
	
	if(player_state.gravity.current != player_state.gravity.previous):
		var rotations = {  
			'DOWN' : 0,
			'RIGHT': 90,
			'UP'   : 180,
			'LEFT' : 270
		}

		var dir = player_state.gravity.get()
		self.set_rotd(rotations[player_state.gravity.getKey()])
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, dir) #Change Gravity Direction


	for key in ['LEFT', 'RIGHT']:
		if((player_state.move.get() == player_state.move_directions[key]) and self_collision.is_colliding()):
			var mult = {false : -1, true : 1}
			var speed = traits.SPEED * mult[player_state.move.get() == player_state.move_directions.RIGHT]
			if(player_state.gravity.is(['LEFT', 'RIGHT'])):
				set_axis_velocity(Vector2(0, speed))
			else:
				set_axis_velocity(Vector2(speed, 0))


	if(self_collision.is_colliding()):
		if(player_state.jump.get() == player_state.jumps.JUMPING):
			set_axis_velocity(-(player_state.gravity.get() * traits.JUMP_HEIGHT))
			animation_player.play("Robot_jump")
			player_state.jump_frame = get_tree().get_frame()
			player_state.jump.set(player_state.jumps.NOT_JUMPING)


		if(get_tree().get_frame() - player_state.jump_frame > 20 && (player_state.jump.get() == player_state.jumps.NOT_JUMPING)):
			player_state.jump.set(player_state.jumps.NOT_JUMPING)
						
			if(player_state.move.get() == player_state.move_directions.NONE):
				animation_player.play("Robot_stand")
			elif(player_state.move.get() != (player_state.move_directions.LEFT + player_state.move_directions.RIGHT)): #Avoid trying to walk both ways
				if(animation_player.get_current_animation() != "Robot_walk"):
					animation_player.play("Robot_walk")


	if(player_state.move.get() == (player_state.move_directions.LEFT + player_state.move_directions.RIGHT) and self_collision.is_colliding()):
		animation_player.play("Robot_stand")

