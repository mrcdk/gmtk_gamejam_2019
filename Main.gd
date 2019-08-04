extends Node

onready var PointerBody = find_node('PointerBody')
onready var PinJointPointer = find_node('PinJointPointer')

onready var PhoneLine = find_node('PhoneLine')
onready var PhoneAnchor = find_node('PhoneAnchor')
onready var Phone = find_node('Phone')

func _ready():
	randomize()
	_on_SpawnTimer_timeout()
	PhoneLine.points = PoolVector2Array([PhoneAnchor.global_position, Phone.global_position])
	
func _input(event):
	if event is InputEventKey and not event.has_meta('fake'):
		get_tree().set_input_as_handled()
		
func _physics_process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	PointerBody.global_position = mouse_position
	PinJointPointer.global_position = mouse_position
	PhoneLine.points[0] = PhoneAnchor.global_position
	PhoneLine.points[1] = Phone.global_position
	

func _on_SpawnTimer_timeout():
	var other = preload("res://OtherCar.tscn").instance()
	other.top_lane = $Lanes/TopLane
	other.middle_lane = $Lanes/MiddleLane
	other.bottom_lane = $Lanes/BottomLane
	add_child(other)
	$SpawnTimer.start(rand_range(2, 4))
	
	var v = Vector2(rand_range(-2, 2), rand_range(-1, 2))
	print('changing gravity to %s' % v)
	#v = Vector2(0, 0)
	Physics2DServer.area_set_param(get_viewport().world_2d.space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, v)


func _on_NoteTest_captured(node, pressed):
	if pressed:
		PinJointPointer.node_a = PointerBody.get_path()
		PinJointPointer.node_b = node.get_path()
	else:
		PinJointPointer.node_a = PointerBody.get_path()
		PinJointPointer.node_b = PointerBody.get_path()
