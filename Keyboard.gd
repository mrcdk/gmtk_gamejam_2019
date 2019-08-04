extends Node2D

func _ready():
	for child in $Model/Keys.get_children():
		child.connect('button_down', self, "_on_button_button_down", [child])
		child.connect('button_up', self, "_on_button_button_up", [child])
		child.text = child.name.capitalize()
		
func _send_key(scancode, pressed):
	var ev = InputEventKey.new()
	ev.pressed = pressed
	ev.scancode = scancode
	ev.unicode = scancode
	ev.set_meta('fake', true)
	get_viewport().input(ev)
	
func _scancode(name):
	var result = 0
	match name:
		'backspace':
			result = KEY_BACKSPACE
		'enter':
			result = KEY_ENTER
		'space':
			result = KEY_SPACE
		_:
			result = OS.find_scancode_from_string(name)
			
	return result
	
func _on_button_button_down(button):
	_send_key(_scancode(button.name), true)
	$AudioStreamPlayer.play()
	
func _on_button_button_up(button):
	_send_key(_scancode(button.name), false)
