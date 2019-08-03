extends Node

func _ready():
	randomize()
	_on_SpawnTimer_timeout()
	
func _input(event):
	if event is InputEventKey and not event.has_meta('fake'):
		get_tree().set_input_as_handled()

func _on_SpawnTimer_timeout():
	var other = preload("res://OtherCar.tscn").instance()
	other.top_lane = $Lanes/TopLane
	other.middle_lane = $Lanes/MiddleLane
	other.bottom_lane = $Lanes/BottomLane
	add_child(other)
	$SpawnTimer.start(rand_range(2, 4))
	
	var v = Vector2(rand_range(-2, 2), rand_range(0.8, 2))
	print('changing gravity to %s' % v)
	Physics2DServer.area_set_param(get_viewport().world_2d.space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, v)
