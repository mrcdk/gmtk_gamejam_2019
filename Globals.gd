extends Node

signal car_crashed()
signal login_failed()
signal login_succeeded()

var questions:Array = []
var current_question:QuestionResource = null

func _init():
	_fill_questions()

func _enter_tree():
	shuffle_question()
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(preload('res://assets/hand.png'), Input.CURSOR_POINTING_HAND, Vector2(17, 5))
	get_tree().connect("node_added", self, "_on_node_added")
	
func shuffle_question():
	questions.shuffle()
	var i = 0
	var selected_question = questions[i]
	while current_question == selected_question:
		i += 1
		if i > questions.size() - 1:
			selected_question = questions[0]
			break
		selected_question = questions[i]
		
	current_question = selected_question
	print('Selected question %s' % selected_question.get_path())
	
func check_login(user, password):
	var correct_user = current_question.user.to_lower() == user.to_lower()
	var correct_password = current_question.password.to_lower() == password.to_lower()
	
	if correct_user and correct_password:
		emit_signal("login_succeeded")
	else:
		emit_signal("login_failed")
		
func _fill_questions():
	var dir = Directory.new()
	if dir.open('res://questions') == OK:
		dir.list_dir_begin(true, true)
		var file = dir.get_next()
		while file != "":
			var path = 'res://questions/%s' % file
			if ResourceLoader.exists(path):
				var resource = load(path)
				if resource is QuestionResource:
					print('Adding %s to questions' % file)
					questions.push_back(resource)
			file = dir.get_next()
		dir.list_dir_end()
	
func _on_node_added(node):
	if node is Control:
		#print('Control %s' % node.name)
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
