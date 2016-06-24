
extends StaticBody2D

var directional_collision
var timer

func _ready():
	set_fixed_process(true)

	directional_collision = get_node("RayCast2D")
	directional_collision.add_exception(self)

func _fixed_process(delta):
	if(directional_collision.is_colliding()):
		self.queue_free()
