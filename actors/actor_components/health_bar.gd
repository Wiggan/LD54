extends Sprite3D

@onready var shadow = $shadow
@onready var progress = $progress


var shadow_tween
var progress_tween
var fade_tween

func get_shadow_tween():
	if shadow_tween:
		shadow_tween.kill()
	shadow_tween = create_tween()
	return shadow_tween


func get_progress_tween():
	if progress_tween:
		progress_tween.kill()
	progress_tween = create_tween()
	return progress_tween
		
func get_fade_tween():
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	return fade_tween
	
func _ready():
	add_to(shadow.region_rect.size.x)
	pass#modulate = Color.TRANSPARENT
	
func add_to(new_value):
	#modulate = Color.WHITE
	var region = Rect2(Vector2.ZERO, Vector2(new_value, shadow.texture.height))
	shadow.region_rect = region
	get_progress_tween().tween_property(progress, "region_rect", region, 0.5)
	#get_fade_tween().tween_property(self, "modulate", Color.TRANSPARENT, 1).set_delay(1)

func reduce_to(new_value):
	#modulate = Color.WHITE
	var region = Rect2(Vector2.ZERO, Vector2(max(new_value, 0.1), shadow.texture.height))
	#if new_value == 0:
	#	get_fade_tween().tween_property(self, "modulate", Color.TRANSPARENT, 1).set_delay(1)
	progress.region_rect = region
	get_shadow_tween().tween_property(shadow, "region_rect", region, 0.5)
	

