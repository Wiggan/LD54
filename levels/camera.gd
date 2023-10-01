extends Camera3D

var light 
# Called when the node enters the scene tree for the first time.

func _ready():
	light = get_tree().get_nodes_in_group("Light").front()
	light.shrinked.connect(on_shrink)
	
func on_shrink():
	create_tween().tween_property(self, "position", position + Vector3.FORWARD * 0.8, 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
