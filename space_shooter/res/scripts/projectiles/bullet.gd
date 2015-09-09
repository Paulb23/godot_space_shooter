extends Sprite

var speed
var target_pos = null
var parent = null
var dmg = 0
var dead = 0

func get_health():
	return !dead

func set_speed(speed):
	self.speed = speed

func set_taget(target):
	target_pos = target

func collision(body):
	if (body.get_name() == "player" && parent == "player"):
		return
	if (body.get_name() != "player" && parent != "player"):
		return
	if (dead == 0):
		get_node("Area2D").queue_free()
		dead = 1
		get_node("SamplePlayer2D").play("hit")
		get_node("AnimationPlayer").play("death")
		get_parent().get_node("main_camrea").shake(5, 5)
		if (body.has_method("hit")):
			body.hit(dmg)

#func area_collision(area):
	#if (dead == 0):
	#	dead = 1
	#	get_node("Area2D").queue_free()
	#	get_node("SamplePlayer2D").play("hit")
	#	get_node("AnimationPlayer").play("death")
	#	get_parent().get_node("main_camrea").shake(5, 5)
	#	if (area.has_method("hit")):
	#		area.hit(dmg)

func _fixed_process(delta):
	if (dead == 0):
		var direction = target_pos - get_pos()
		direction = direction.normalized( )
		direction.x = direction.x * speed * delta 
		direction.y = direction.y * speed * delta
		set_pos(get_pos() + direction)
		
		if (get_pos().x > 384 || get_pos().x < -4 || get_pos().distance_to(target_pos) <= 5):
			queue_free()
	else:
		if (!get_node("AnimationPlayer").is_playing()):
			queue_free()

func _ready():
	get_node("Area2D").connect("body_enter", self, "collision")
	get_node("Area2D").connect("area_enter", self, "area_collision")
	set_fixed_process(true)