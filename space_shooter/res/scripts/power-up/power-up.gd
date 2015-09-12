extends Sprite

var powerup_type = -1

# power up list
var powerups = [
		"triple_shot",
		"double_shot",
		"shotgun",
		"invulnerability",
		"health_up"
]

# sprite list in the same order as powerups!
var powerups_sprite = [
		"res://res/sprites/power-up/triple_cannon.png",
		"res://res/sprites/power-up/double_cannon.png",
		"res://res/sprites/power-up/shotgun.png",
		"res://res/sprites/power-up/invulnerability.png",
		"res://res/sprites/power-up/health_up.png"
]

func collision(body):
	if (body.get_name() == "player"):
		body.power_up(powerup_type)
		queue_free()
	
func set_up(type):
	powerup_type = 0
	var sprite = load(powerups_sprite[0])
	set_texture(sprite)
	powerup_type = powerups[0]

func _ready():
	set_up(1)
	get_node("Area2D").connect("body_enter", self, "collision")
	set_fixed_process(true)