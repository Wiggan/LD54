extends Label3D

func fade():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 2)
	tween.tween_callback(queue_free)
