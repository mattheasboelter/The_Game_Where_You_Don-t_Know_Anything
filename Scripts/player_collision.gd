
extends Node2D

var sensor1
var sensor2

var colliding = false

func _ready():
	set_fixed_process(true)

	sensor1 = get_node("sensor1")
	sensor2 = get_node("sensor2")

	sensor1.add_exception(get_parent())
	sensor1.add_exception(get_parent())

func _fixed_process(delta):
	colliding = false

	if(sensor1.is_colliding() or sensor2.is_colliding()):
		colliding = true
