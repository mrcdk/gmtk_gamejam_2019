extends RigidBody2D


onready var UsernameEdit = find_node('UsernameEdit')
onready var PasswordEdit = find_node('PasswordEdit')
onready var PasswordCheckbox = find_node('PasswordCheckbox')

onready var WarningPanel = find_node('WarningPanel')
onready var ImageSign = find_node('ImageSign')
onready var WarningLabel = find_node('WarningLabel')
onready var WarningTimer = find_node('WarningTimer')
onready var ProgressBarTimer = find_node('ProgressBar')

var ok_image = preload("res://assets/message-24-ok.png")
var warning_image = preload("res://assets/message-24-warning.png")
var error_image = preload("res://assets/message-24-error.png")

func _ready():
	WarningPanel.visible = false
	Globals.connect('car_crashed', self, "_on_car_crashed")
	Globals.connect('login_failed', self, "_on_login_failed")
	Globals.connect('login_succeeded', self, "_on_login_succeeded")

func _process(delta):
	if not WarningTimer.is_stopped():
		ProgressBarTimer.value = WarningTimer.time_left
	
func show_warning(texture, text, start_timer = true):
	if not WarningTimer.is_stopped():
		return
	ImageSign.texture = texture
	WarningLabel.text = text
	WarningPanel.visible = true
	if start_timer:
		ProgressBarTimer.visible = true
		ProgressBarTimer.max_value = 5
		WarningTimer.start(5)
	else:
		ProgressBarTimer.visible = false
		
	UsernameEdit.release_focus()
	PasswordEdit.release_focus()
	
func _erase(string:String):
	if len(string) == 0:
		return ""
	string.erase(len(string) - 1, 1)
	return string
	
func _on_car_crashed():
	show_warning(warning_image, "Crash detected! Input data may be corrupted!")
	if randi() % 2 == 0:
		UsernameEdit.text = _erase(UsernameEdit.text)
	elif randi() % 2 == 0:
		PasswordEdit.text = _erase(PasswordEdit.text)
		
	PasswordCheckbox.pressed = false
	

func _on_login_failed():
	show_warning(error_image, "Login failed! Try again!")
	UsernameEdit.text = ""
	PasswordEdit.text = ""
	$AudioStreamPlayer.stream = preload('res://assets/432886__xtrgamr__lfs-vox6.wav')
	$AudioStreamPlayer.play()
	
func _on_login_succeeded():
	show_warning(ok_image, "Congratulations!", false)
	$AudioStreamPlayer.stream = preload('res://assets/404358__kagateni__success.wav')
	$AudioStreamPlayer.play()

func _on_LoginButton_pressed():
	Globals.check_login(UsernameEdit.text, PasswordEdit.text)

func _on_WarningTimer_timeout():
	WarningPanel.visible = false
	WarningTimer.stop()
