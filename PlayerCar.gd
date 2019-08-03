extends Area2D

export (NodePath) var top_lane_path
export (NodePath) var middle_lane_path
export (NodePath) var bottom_lane_path

export (int, "Top, Middle, Bottom") var lane = 0

onready var top_lane = get_node(top_lane_path)
onready var middle_lane = get_node(middle_lane_path)
onready var bottom_lane = get_node(bottom_lane_path)

func _ready():
	_change_lane()
	
func _process(delta):
	pass

func _change_lane():
	match lane:
		0:
			global_position = top_lane.global_position
		1:
			global_position = middle_lane.global_position
		2:
			global_position = bottom_lane.global_position


func _on_LeftButton_pressed():
	lane -= 1
	lane = clamp(lane, 0, 2)
	_change_lane()

func _on_RightButton_pressed():
	lane += 1
	lane = clamp(lane, 0, 2)
	_change_lane()


func _on_PlayerCar_area_entered(area):
	if area.is_in_group('other_car'):
		print('oh fuck')
