extends Area2D

var top_lane
var middle_lane
var bottom_lane

var lane = 0
var speed = 0

func _ready():
	speed = rand_range(180, 380)
	_change_lane()
	
func _process(delta):
	global_position.x -= speed * delta
	
func kill():
	$CPUParticles2D.emitting = true
	$CollisionShape2D.set_deferred('disabled', true)
	$Model.visible = false
	speed = 0
	$AudioStreamPlayer.play()
	yield($AudioStreamPlayer, "finished")
	queue_free()
	

func _change_lane():
	match lane:
		0:
			global_position = top_lane.global_position
		1:
			global_position = middle_lane.global_position
		2:
			global_position = bottom_lane.global_position
			
	global_position.x = 1500

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
