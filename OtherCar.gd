extends Area2D

var top_lane
var middle_lane
var bottom_lane

var lane = 0
var speed = 0

func _ready():
	lane = randi() % 3
	speed = rand_range(180, 380)
	_change_lane()
	
func _process(delta):
	global_position.x -= speed * delta

func _change_lane():
	match lane:
		0:
			global_position = top_lane.global_position
		1:
			global_position = middle_lane.global_position
		2:
			global_position = bottom_lane.global_position
			
	global_position.x = 1500
