extends RigidBody2D

signal captured(node, pressed)

export (String, MULTILINE) var text = ""

export (Array, Color) var colors = []

func _ready():
	$Label.text = text
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	$CollisionShape2D.shape.extents.y = $Label.rect_size.y / 2
	
	colors.shuffle()
	
	var style = $Label.get_stylebox("normal")
	style.bg_color = colors[0]
	style.border_color = style.bg_color.darkened(0.1)

func _on_Label_gui_input(event):
	if event is InputEventMouseButton:
		raise()
		emit_signal('captured', self, event.is_pressed())
