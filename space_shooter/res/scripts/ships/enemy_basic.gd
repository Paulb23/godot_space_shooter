extends KinematicBody2D

var bullet = load("res://res/scenes/projectiles/bullet.scn")
var speed = 100
var health = 20
var shoot_delay = 80
var dead = 0

var last_shoot = 0

func hit(dmg):
	health -= dmg
	if (health <= 0 && dead == 0):
		dead = 1
		get_parent().enemy_killed()
		get_parent().add_score("enemy_basic")
		get_node("AnimationPlayer").play("death")
		get_node("SamplePlayer2D").play("explode")
	
func get_health():
	return health


func shoot_bullet(start_pos, target_pos, bull_speed):
	var node = bullet.instance()
	node.parent = "ememy_basic"
	node.set_pos(start_pos)
	node.set_speed(bull_speed)
	node.set_taget(target_pos)
	get_parent().add_child(node)

func weapon_shoot():
	last_shoot = shoot_delay

	get_node("SamplePlayer2D").play(str("shoot_", ceil(rand_range(1, 6))))
	if (get_node("AnimationPlayer").get_current_animation() != "shoot" || get_node("AnimationPlayer").is_playing() == false):
		get_node("AnimationPlayer").play("shoot")

	shoot_bullet(get_pos(), Vector2(get_pos().x - 400, get_pos().y), 200)

func _fixed_process(delta):

	if (dead == 0):
		var direction = Vector2(0,0)
		direction += Vector2(-1, 0)
		
		if (last_shoot == 0 && get_pos().x > 8 && get_pos().x < 384):
			weapon_shoot()
		else:
			if(get_node("AnimationPlayer").is_playing() == false):
				get_node("AnimationPlayer").play("normal")
		
		if (last_shoot > 0):
			last_shoot -= 1
		
		var motion = direction * speed * delta
		move( motion )
		
		if (is_colliding()):
			var n = get_collision_normal()
			motion = n.slide( motion ) 
			direction = n.slide( direction )
			move( motion )
	else:
		if (!get_node("AnimationPlayer").is_playing()):
			queue_free()

func _ready():
	set_fixed_process(true)