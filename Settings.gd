extends PanelContainer

onready var VolumeSlider = find_node('VolumeSlider')

var master_idx = AudioServer.get_bus_index('Master')

func _ready():
	var volume = AudioServer.get_bus_volume_db(master_idx)
	VolumeSlider.value = db2linear(volume)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause(not visible)
		
func pause(value):
	visible = value
	get_tree().paused = visible
	
func _on_ContinueButton_pressed():
	pause(false)

func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(master_idx, linear2db(value))

func _on_QuitButton_pressed():
	get_tree().change_scene('res://MainMenu.tscn')
	pause(false)
