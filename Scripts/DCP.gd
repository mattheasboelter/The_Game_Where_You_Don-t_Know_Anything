
extends StaticBody2D

var directional_collision
var timer

func _ready():
	set_fixed_process(true)

	timer = get_node("Timer")
	directional_collision = get_node("RayCast2D")
	directional_collision.add_exception(self)

func _fixed_process(delta):
	if(directional_collision.is_colliding()):
		if(timer.get_time_left() == 0):
			timer.start()



func _on_Timer_timeout():
	self.queue_free()
