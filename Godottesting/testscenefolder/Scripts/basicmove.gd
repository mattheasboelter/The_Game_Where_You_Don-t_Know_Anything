extends RigidBody2D

# Constants for Gravity Direction
const DOWN = Vector2(0, 1)
const UP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)

var self_collision

var is_moving_left = false
var is_moving_right = false
var is_jumping = false

var jump_timer = 0;

var speed = 70
var jump_height = 200

func _ready():
	# set_process(true)
	set_fixed_process(true)
	set_process_input(true)

	self_collision = get_node('player_collision_sensor')
	self_collision.add_exception(self)

	set_mode(2) # Disallow rotation on the player


func _input(event):
	# Handle Keypress Events
	if(event.is_pressed()):
		# Handle MOVE LEFT Event
		if(event.is_action('MOVE_LEFT') and not event.is_echo()):
			is_moving_left = true
		# Handle MOVE RIGHT Event
		if(event.is_action('MOVE_RIGHT') and not event.is_echo()):
			is_moving_right = true
		# Handle JUMP Event
		if(event.is_action('JUMP') and not event.is_echo()):
			if(self_collision.is_colliding()):
				Jump()

		### Handle Gravity changes
		# Down
		if(event.is_action('GRAVITY_DOWN') and not event.is_echo()):
			ChangeGravityDirection(DOWN)
		# Up
		if(event.is_action('GRAVITY_UP') and not event.is_echo()):
			ChangeGravityDirection(UP)
		# Right
		if(event.is_action('GRAVITY_RIGHT') and not event.is_echo()):
			ChangeGravityDirection(RIGHT)
		# Left
		if(event.is_action('GRAVITY_LEFT') and not event.is_echo()):
			ChangeGravityDirection(LEFT)

	# Handle Key Release Events
	else:
		# Handle MOVE LEFT Event
		if(event.is_action('MOVE_LEFT') and not event.is_echo()):
			is_moving_left = false
		# Handle MOVE RIGHT Event
		if(event.is_action('MOVE_RIGHT') and not event.is_echo()):
			is_moving_right = false


func _fixed_process(delta):
	var x = get_pos().x
	var y = get_pos().y

	# move left
	if(is_moving_left):
		if(self_collision.is_colliding()):
			set_axis_velocity(Vector2(-speed, 0))

	# move right
	if(is_moving_right):
		if(self_collision.is_colliding()):
			set_axis_velocity(Vector2(speed, 0))


func Jump():
	set_axis_velocity(Vector2(0, -jump_height))

func ChangeGravityDirection(direction):
	var rotation

	if(direction == Vector2(0, 1)):
		rotation = 0
	elif(direction == Vector2(0, -1)):
		rotation = 180
	elif(direction == Vector2(1, 0)):
		rotation = -90
	elif(direction == Vector2(-1, 0)):
		rotation = 90

	self_collision.set_rot(rotation)

	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, direction) #Change Gravity Direction
