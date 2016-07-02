var StateMachine = preload("StateMachine.gd")
	
const move_directions = {
	'NONE' : 0,
	'LEFT' : 1,
	'RIGHT': 2
}
var move = StateMachine.new("move", move_directions.NONE, move_directions)


const jumps = {
	'NOT_JUMPING' : 0,
	'JUMPING'     : 1,
}
var jump = StateMachine.new("jump", jumps.NOT_JUMPING, jumps)
var jump_frame

const gravity_directions = {
	'DOWN' : Vector2(0, 1),
	'UP'   : Vector2(0, -1),
	'RIGHT': Vector2(1, 0),
	'LEFT' : Vector2(-1, 0)
}

var gravity = StateMachine.new("gravity", gravity_directions.DOWN, gravity_directions)

func update():
	move.update()
	jump.update()
	gravity.update()
	
func reset():
	move.reset()
