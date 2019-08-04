extends Node

onready var PointerBody = find_node('PointerBody')
onready var PinJointPointer = find_node('PinJointPointer')

onready var PhoneLine = find_node('PhoneLine')
onready var PhoneAnchor = find_node('PhoneAnchor')
onready var Phone = find_node('Phone')

onready var ChildrenSound = find_node('ChildrenSound')

onready var OtherCars = find_node('OtherCars')
onready var Notes = find_node('Notes')

onready var Settings = find_node('Settings')

var last_lane = -1

var winner = false

func _ready():
	winner = false
	Music.play_music(preload("res://assets/hitman-by-kevin-macleod.ogg"))
	
	ChildrenSound.stop()
	ChildrenSound.stream = preload("res://assets/172096__vosvoy__adolescent-screaming01-loop.wav")
	ChildrenSound.pitch_scale = 1.5
	ChildrenSound.volume_db = -12
	ChildrenSound.play()
	
	Globals.connect("login_succeeded", self, "_on_login_succeeded")
	_on_SpawnTimer_timeout()
	_on_GravityTimer_timeout()
	PhoneLine.points = PoolVector2Array([PhoneAnchor.global_position, Phone.global_position])
	
	for question in Globals.current_question.questions:
		var note = preload("res://NoteTest.tscn").instance()
		note.connect("captured", self, "_on_NoteTest_captured")
		note.text = question
		Notes.add_child(note)
		note.global_position = Vector2(rand_range(300, 900), rand_range(300, 600))
		note.rotation_degrees = rand_range(0, 360)
	
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
	if winner: return
	
	var other = preload("res://OtherCar.tscn").instance()
	other.top_lane = $Lanes/TopLane
	other.middle_lane = $Lanes/MiddleLane
	other.bottom_lane = $Lanes/BottomLane
	var lane = randi() % 3
	while lane == last_lane:
		lane = randi() % 3
	last_lane = lane
	other.lane = lane
	OtherCars.add_child(other)
	$SpawnTimer.start(rand_range(3, 6))


func _on_NoteTest_captured(node, pressed):
	if pressed:
		PinJointPointer.node_a = PointerBody.get_path()
		PinJointPointer.node_b = node.get_path()
	else:
		PinJointPointer.node_a = PointerBody.get_path()
		PinJointPointer.node_b = PointerBody.get_path()


func _on_GravityTimer_timeout():
	var v = Vector2(rand_range(-2, 2), rand_range(-1, 2))
	print('changing gravity to %s' % v)
	#v = Vector2(0, 0)
	Physics2DServer.area_set_param(get_viewport().world_2d.space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, v)
	$GravityTimer.start(rand_range(2, 3))
	
func _on_login_succeeded():
	Music.play_music(preload("res://assets/brightly-fancy-by-kevin-macleod.ogg"))
	winner = true
	
	for car in OtherCars.get_children():
		if car.is_in_group('other_car'):
			car.kill()
			
	for note in Notes.get_children():
		note.queue_free()
	
	ChildrenSound.stop()
	ChildrenSound.stream = preload("res://assets/403058__wrc4all__laughs.wav")
	ChildrenSound.pitch_scale = 1
	ChildrenSound.volume_db = -6
	ChildrenSound.play()
	
	$CanvasLayer/LeftButton.disabled = true
	$CanvasLayer/RightButton.disabled = true
	
	$WinTween.interpolate_property($PlayerCar, 'global_position:x', $PlayerCar.global_position.x, 1400, 10, Tween.TRANS_SINE, Tween.EASE_IN)
	$WinTween.start()
	yield($WinTween, "tween_all_completed")
	get_tree().change_scene("res://MainMenu.tscn")
