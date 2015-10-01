extends Node2D

const FRONT = 3
const FRONT_RIGHT = 4
const RIGHT = 5
const RIGHT_BOTTOM = 6
const BOTTOM = 7
const BOTTOM_LEFT = 8
const LEFT = 1
const LEFT_FRONT = 2

const INNER_COLOR = Color(1.0, 0.5, 1.0)
const OUTER_COLOR = Color(0.0, 0.5, 1.0)
var show_outer_circle = true

var inner_pos = Vector2(0,0)
var inner_radius = 2

var outer_pos = Vector2(0, 0)
var outer_radious = 15

var center_pos = Vector2(0, 0)

func getDistFromCenter():
	return sqrt(pow(inner_pos.x - outer_pos.x, 2) + pow(inner_pos.y - outer_pos.y, 2))

func get_angle():
	var angle = float(rad2deg(atan2(inner_pos.y - outer_pos.y, inner_pos.x - outer_pos.x)))
	if (angle < 0):
		angle += 360
	return angle

func _input(event):
	center_pos = get_pos()
	#if (event == InputEvent.SCREEN_TOUCH || event == InputEvent.SCREEN_DRAG):
	if (event.type == InputEvent.MOUSE_MOTION):
		var dx = abs(event.x - center_pos.x)
		var dy = abs(event.y - center_pos.y)
		if (dx + dy <= outer_radious + 5):
			inner_pos.x = -(get_pos().x - event.x)
			inner_pos.y = -(get_pos().y - event.y)
		else:
			inner_pos.x = 0
			inner_pos.y = 0
	update()


func _draw():
	if (show_outer_circle):
		draw_circle(outer_pos, outer_radious, OUTER_COLOR)
	draw_circle(inner_pos, inner_radius, INNER_COLOR)
	update()

func _ready():
	set_process_input(true)
	pass