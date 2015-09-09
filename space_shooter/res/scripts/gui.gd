extends Node2D

func _fixed_process(delta):
	get_node("wave_num").set_text(str(get_parent().get_current_wave()))
	get_node("points").set_text(str(get_parent().get_current_score()))
	
	get_node("sheild_bar").set_percentage(get_parent().get_current_shield_percent())
	
	var health = get_parent().get_current_health()
	if (health == 2):
		get_node("heart_3").set_frame(1)
	if (health == 1):
		get_node("heart_3").set_frame(1)
		get_node("heart_2").set_frame(1)
	if (health == 0):
		get_node("heart_3").set_frame(1)
		get_node("heart_2").set_frame(1)
		get_node("heart_1").set_frame(1)

func _ready():
	set_fixed_process(true)