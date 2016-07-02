var previous
var current
var next
var default

var name
var states

func _init(name, initial, states):
	self.name = name
	#self.next = initial
	self.default = initial
	self.reset()
	self.states = states

func update():
	self.previous = self.current
	self.current = self.next

func set(next):
	self.next = next
	
func set_inc(next):
	self.next += next

func reset():
	self.next = self.default
	self.update()

func get():
	return self.current

func is(keys):
	for key in keys:
		if(current == states[key]):
			return true

func getKey():
	for key in states.keys():
		if(current == states[key]):
			return key