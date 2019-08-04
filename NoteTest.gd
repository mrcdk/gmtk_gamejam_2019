extends RigidBody2D

signal captured(node, pressed)

export (String, MULTILINE) var text = ""

func _ready():
	$Label.text = text

func _on_Label_gui_input(event):
	if event is InputEventMouseButton:
		raise()
		emit_signal('captured', self, event.is_pressed())
