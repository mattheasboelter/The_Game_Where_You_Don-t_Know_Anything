extends RigidBody2D

# Constants for Gravity Direction
const DOWN = Vector2(0, 1)
const UP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)

var self_collision
var animation_player
var sprite

var STANDING = 0
var MOVING_LEFT = 1
var MOVING_RIGHT = 2
var JUMPING = 3

var player_state # Current Character state

var jump_timer = 0;

var speed = 70
var jump_height = 200

func _ready():
	# set_process(true)
	set_fixed_process(true)
	set_process_input(true)

	self_collision = get_node('player_collision_sensor')
	self_collision.add_exception(self)

	animation_player = get_node("AnimatedSprite/AnimationPlayer")
	sprite = get_node("AnimatedSprite")

	set_mode(2) # Disallow rotation on the player

	animation_player.play("Robot_stand")


func _input(event):
	# Handle Keypress Events
	if(event.is_pressed()):
		# Handle MOVE LEFT Event
		if(event.is_action('MOVE_LEFT') and not event.is_echo()):
			Move(MOVING_LEFT)
		# Handle MOVE RIGHT Event
		if(event.is_action('MOVE_RIGHT') and not event.is_echo()):
			Move(MOVING_RIGHT)
		# Handle JUMP Event
		if(event.is_action('JUMP') and not event.is_echo()):
			if(self_collision.is_colliding()):
				player_state = JUMPING
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
			player_state = STANDING
			animation_player.play("Robot_stand")
		# Handle MOVE RIGHT Event
		if(event.is_action('MOVE_RIGHT') and not event.is_echo()):
			player_state = STANDING
			animation_player.play("Robot_stand")


func _fixed_process(delta):
	var x = get_pos().x
	var y = get_pos().y

	# move left
	if(player_state == MOVING_LEFT):
		if(self_collision.is_colliding()):
			set_axis_velocity(Vector2(-speed, 0))
			sprite.set_flip_h(true)

	# move right
	if(player_state == MOVING_RIGHT):
		if(self_collision.is_colliding()):
			set_axis_velocity(Vector2(speed, 0))


	if(player_state == JUMPING):
		if(self_collision.is_colliding()):
			player_state = STANDING


func Jump():
	set_axis_velocity(Vector2(0, -jump_height))

func Move(move_direction):
	animation_player.play("Robot_walk")

	if(move_direction == MOVING_LEFT):
		sprite.set_flip_h(true)
		player_state = MOVING_LEFT

	if(move_direction == MOVING_RIGHT):
		sprite.set_flip_h(false)
		player_state = MOVING_RIGHT

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
