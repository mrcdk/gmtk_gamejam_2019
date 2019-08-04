extends PanelContainer

func _ready():
	Music.play_music(preload("res://assets/brightly-fancy-by-kevin-macleod.ogg"))
	print(Engine.get_version_info())

func _on_PlayButton_pressed():
	Globals.shuffle_question()
	get_tree().change_scene("res://Main.tscn")
