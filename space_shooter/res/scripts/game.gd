extends Node2D

# game states
const NEW_WAVE = 0
const WAVE = 1
const SHOP = 2

# current game status
var currentState = 0
var currentWave = 0

# wave status
var enemiesToSpawn = 0
var enemiesThisWave = 0
var enemiesKilled = 0

# between wave countdown
var countdown = 0
var timer = Timer.new()

# enemy arraws split by diffculty type
var easy = [
			load("res://res/scenes/ships/enemy_basic.scn")
			]


########################
# inits game scene     #
########################
func _ready():
	get_node("left_edge").connect("body_enter", self, "left_edge_collision")
	add_child(timer)
	currentState = NEW_WAVE
	set_fixed_process(true)


########################
#   game loop          #
########################
func _fixed_process(delta):
	
	# check if we need to change waves, and do so
	if (currentState == NEW_WAVE && countdown == 0):
		new_wave()
		
	# if all enemeies are killed request new wave
	if (enemiesKilled == enemiesThisWave):
		currentState = NEW_WAVE


########################
# spawns the waves     #
########################
func new_wave():

	# notify we are in the count down
	countdown = 1
	
	# update wave number + show text
	currentWave += 1
	get_node("wave_count_down").set_text(str("Wave ", currentWave))
	
	# start the count down
	timer.set_one_shot(true)
	if (currentWave == 1):
		timer.set_wait_time(1)
	else:
		timer.set_wait_time(3)
	timer.start()
	yield(timer, "timeout")
	
	# hide text and start the wave
	get_node("wave_count_down").set_text("")
	countdown = 0
	currentState = WAVE
	enemiesThisWave = 10 + (5 * currentWave)
	enemiesToSpawn = enemiesThisWave
	enemiesKilled = 0
	spawn_enemy()


########################
# spawns the waves     #
########################
func spawn_enemy():
	
	# randomly chooses a diffucly level
	# var diff = ceil(rand_range(0, 3))
	
	# spawn from that array
	var node = easy[ceil(rand_range(0, easy.size() - 1))].instance()
	
	# set up ememy
	node.set_pos(Vector2(rand_range(395, 550), rand_range(23, 191)))
	
	# spawn ememy
	add_child(node)
	
	# update counters
	enemiesToSpawn -= 1
				
	# random spawn times
	timer.set_one_shot(true)
	timer.set_wait_time(rand_range(0, 3))
	timer.start()
	yield(timer, "timeout")
	
	#keep spawing till we run out
	if (enemiesToSpawn > 0 ):
		spawn_enemy()


##############################
#  left edge callback        #
##############################
func left_edge_collision(body):
	body.queue_free()
	enemiesKilled += 1


##############################
# registers a killed enemy   #
##############################
func enemy_killed():
	enemiesKilled += 1


#################################
#  adds score basced on type    #
#################################
func add_score(name):
	var score = 0
	if (name == "enemy_basic"):
		score = ceil(rand_range(10, 20))
		get_node("player").add_score(score)
	else:
		score = 0
		get_node("player").add_score(1)
	return score
 

##############################
#  sets the game state       #
##############################
func set_state(state):
	self.gameState = state


##############################
# gets the current wave      #
##############################
func get_current_wave():
	return currentWave


##############################
# gets the current score     #
##############################
func get_current_score():
	var player = get_node("player") # check for null player in case it has been deleted
	if (player != null):
		return player.get_score()
	else:
		return 0
		

##############################
# gets the current health    #
##############################
func get_current_health():
	var player = get_node("player") # check for null player in case it has been deleted
	if (player != null):
		return player.get_health()
	else:
		return 0


##############################
# gets the current shield    #
##############################
func get_current_shield_percent():
	var player = get_node("player") # check for null player in case it has been deleted
	if (player != null):
		var decrease = player.maxShieldHealth - player.get_shield()
		var percent_decreace = float(decrease) / float(player.maxShieldHealth)
		return (float(1.00) - (float(percent_decreace)))
	else:
		return 0


##############################
# gets the game state   #
##############################
func get_state():
	return self.gameState





