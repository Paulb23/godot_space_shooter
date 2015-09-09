extends Camera2D

var shakeTime = 0
var amount = 0

func shake(time, amount):
	self.shakeTime = time
	self.amount = amount

func _fixed_process(delta):
	if (shakeTime > 0):
		shakeTime -= 1
		set_offset(Vector2(rand_range(0, amount), rand_range(0, amount)))
	else:
		set_offset(Vector2(0,0))

func _ready():
	set_fixed_process(true)