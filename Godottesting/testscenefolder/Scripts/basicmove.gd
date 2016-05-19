
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	#Just some variables
	var ownX = get_pos().x
	var ownY = get_pos().y
	var speed = 1 #this can change if a speed boost is found
	
	#move left
	if(Input.is_key_pressed(KEY_A)):
		set_pos(Vector2(ownX-speed, ownY))
	
	#move right
	if(Input.is_key_pressed(KEY_D)):
		set_pos(Vector2(ownX+speed, ownY))
		