extends Node

func _enter_tree():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(preload('res://assets/hand.png'), Input.CURSOR_POINTING_HAND, Vector2(17, 5))
	get_tree().connect("node_added", self, "_on_node_added")
	
func _on_node_added(node):
	if node is Control:
		print('Control %s' % node.name)
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
