
extends AnimatedSprite

var animation_player

func _ready():
	#set_fixed_process(true)
	set_process_input(true)
	
	animation_player = get_node("AnimationPlayer")
	
func _input(event):
	if(event.is_pressed()):
		# Handle MOVE LEFT Event
		if(event.is_action('WALK') and not event.is_echo()):
			animation_player.play("RobotWalkCycle")
		if(Input.is_key_pressed(KEY_A)):
			get_node(".").set_flip_h(true)
		if(Input.is_key_pressed(KEY_D)):
			get_node(".").set_flip_h(false)
