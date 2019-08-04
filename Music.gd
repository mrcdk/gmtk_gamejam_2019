extends AudioStreamPlayer

func play_music(music):
	if stream != music:
		stop()
		stream = music
		play()
