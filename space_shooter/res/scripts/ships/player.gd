extends KinematicBody2D

const joystickDeadzone = 1

# types of weapons
const WEAPON_DEFUALT = 0
const WEAPON_DUAL = 1
const WEAPON_TRIPLE = 2
const WEAPON_SHOTGUN = 3

# player weapon status
var currentWeapon = 0
var bullet = null

# dmg status
var shoot_delay = 50
var dmg = 10
var dmgScale = 1

# player status
var speed = 100
var score = 0
var health = 3
var maxShieldHealth = 100
var shieldHealth = 100
var SheildRestoreDelay = 120
var shieldRestoretRate = 1
var max_invulnerability_timer = 100

# timing varables
var last_shoot = 0
var last_hit = 0
var invulnerability_timer = 0


#####################
# inits the player  #
#####################
func _ready():
	switch_weapon(WEAPON_DEFUALT)
	set_fixed_process(true)
	

#####################
#     main loop     #
#####################
func _fixed_process(delta):

	var direction = handle_input()
	
	if (invulnerability_timer > 0):
		invulnerability_timer -= 1
	
	if (last_shoot > 0):
		last_shoot -= 1
			
	if (get_pos().x < 8):
		if (direction.x < 0):
			direction.x = 0
	if (get_pos().x > 384 - 8):
		if (direction.x > 0):
			direction.x = 0

	var motion = direction * speed * delta
	move( motion )
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide( motion ) 
		direction = n.slide( direction )
		move( motion )

	if (last_hit > 0):
		last_hit -= 1
	
	if (last_hit <= 0 && shieldHealth != maxShieldHealth):
		shieldHealth += shieldRestoretRate


#####################
#  collision loop  #
#####################
func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		print("collision")


#####################
#  handles input    #
#####################
func handle_input():
	var direction = Vector2(0,0)
	#if (1):
	if (OS.get_name() == "Android"):
		var joystick = get_parent().get_node("joystick")
		if (abs(joystick.getDistFromCenter()) > joystickDeadzone):
			var speedX = cos(joystick.get_angle() * (PI/180))
			var speedY = sin(joystick.get_angle() * (PI/180))
			direction.x = speedX
			direction.y = speedY
	else :
		if ( Input.is_action_pressed("up") ):
			direction += Vector2(0,-1)
		if ( Input.is_action_pressed("down") ):
			direction += Vector2(0,1)
		if ( Input.is_action_pressed("left") ):
			direction += Vector2(-1,0)
		if ( Input.is_action_pressed("right") ):
			direction += Vector2(1,0)
		if ( Input.is_action_pressed("shoot") && last_shoot == 0):
				weapon_shoot()
		else:
			if(get_node("AnimationPlayer").is_playing() == false):
				get_node("AnimationPlayer").play("normal")
	return direction


#####################
#  switches weapon  #
#####################
func switch_weapon(weapon):
	currentWeapon = weapon

	if (weapon == WEAPON_DEFUALT || weapon == WEAPON_DUAL || weapon == WEAPON_TRIPLE || weapon == WEAPON_SHOTGUN ):
		shoot_delay = 15
		bullet = load("res://res/scenes/projectiles/bullet.scn")
	if (weapon == WEAPON_SHOTGUN ):
		shoot_delay = 20


######################
#  shoots the weapon #
######################
func weapon_shoot():
	last_shoot = shoot_delay

	get_node("SamplePlayer2D").play(str("shoot_", ceil(rand_range(1, 6))))
	if (get_node("AnimationPlayer").get_current_animation() != "shoot" || get_node("AnimationPlayer").is_playing() == false):
		get_node("AnimationPlayer").play("shoot")
		
	if (currentWeapon == WEAPON_DEFUALT):
		shoot_bullet(get_pos(), Vector2(get_pos().x + 400, get_pos().y), 200)
	if (currentWeapon == WEAPON_DUAL):
		shoot_bullet(Vector2(get_pos().x, get_pos().y - 10), Vector2(get_pos().x + 400, get_pos().y - 10), 200)
		shoot_bullet(Vector2(get_pos().x, get_pos().y + 10), Vector2(get_pos().x + 400, get_pos().y + 10), 200)
	if (currentWeapon == WEAPON_TRIPLE):
		shoot_bullet(Vector2(get_pos().x, get_pos().y - 10), Vector2(get_pos().x + 400, get_pos().y - 10), 200)
		shoot_bullet(get_pos(), Vector2(get_pos().x + 400, get_pos().y), 200)
		shoot_bullet(Vector2(get_pos().x, get_pos().y + 10), Vector2(get_pos().x + 400, get_pos().y + 10), 200)
	if (currentWeapon == WEAPON_SHOTGUN):
		shoot_bullet(Vector2(get_pos().x, get_pos().y - 10), Vector2(get_pos().x + 60, get_pos().y - 10), 200)
		shoot_bullet(get_pos(), Vector2(get_pos().x + 80, get_pos().y), 210)
		shoot_bullet(Vector2(get_pos().x, get_pos().y + 10), Vector2(get_pos().x + 60, get_pos().y + 10), 200)


######################
#  Handles Powerups  #
######################
func power_up(powerup_type):
	if (powerup_type == "triple_shot"):
		switch_weapon(WEAPON_TRIPLE)
		
	if (powerup_type == "double_shot"):
		switch_weapon(WEAPON_DUAL)
		
	if (powerup_type == "shotgun"):
		switch_weapon(WEAPON_SHOTGUN)
		
	if (powerup_type == "invulnerability"):
		invulnerability_timer = max_invulnerability_timer
		
	if (powerup_type == "health_up"):
		if (health == 3):
			add_score(100)
		else:
			if (health < 0):
				health = 1
			else:
				health += 1
		
	get_node("SamplePlayer2D").play(str("powerup_", ceil(rand_range(1, 3))))
		

#####################
#   fires a bullet  #
#####################
func shoot_bullet(start_pos, target_pos, bull_speed):
	var node = bullet.instance()
	node.parent = "player"
	node.dmg = dmg * dmgScale
	node.set_pos(start_pos)
	node.set_speed(bull_speed)
	node.set_taget(target_pos)
	get_parent().add_child(node)


#####################
#   called on hit   #
#####################
func hit(dmg):
	if (invulnerability_timer <= 0):
		if (shieldHealth <= 0):
			health -= 1
		else:
			shieldHealth -= 10
		last_hit = SheildRestoreDelay


#####################
#    add score     #
#####################
func add_score(added_score):
	score += added_score


#####################
#   get health      #
#####################
func get_health():
	return health


#####################
#     get score     #
#####################
func get_score():
	return score


#####################
#    get shield     #
#####################
func get_shield():
	return shieldHealth