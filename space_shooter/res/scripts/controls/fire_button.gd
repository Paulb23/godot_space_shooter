extends Node2D

const OUTER_COLOR = Color(0.0, 0.5, 1.0)
var outer_radious = 15
var outer_pos = Vector2(0, 0)

var pressed = false
var eventTouched = InputEvent()

var center_pos = Vector2(0, 0)


func _input(event):
	center_pos = get_pos()
	if (event.type == InputEvent.SCREEN_TOUCH || event.type == InputEvent.SCREEN_DRAG):
		if (event.type == InputEvent.SCREEN_TOUCH):
			eventTouched = event
		var dx = abs(event.x - center_pos.x)
		var dy = abs(event.y - center_pos.y)
		if (dx + dy <= 16):
			pressed = true

func _fixed_process(delta):
	if (!eventTouched.is_pressed()):
		pressed = false
	

func _draw():
	draw_circle(outer_pos, outer_radious, OUTER_COLOR)
	update()

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	pass