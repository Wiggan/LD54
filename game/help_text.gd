extends Label3D

func fade():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 4)
	tween.tween_callback(queue_free)
