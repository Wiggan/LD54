extends "res://levels/building_blocks/base_pillar.gd"
@onready var bumper = $Bumper


func pawn_collided(speed):
	super(speed)
	var tween = create_tween()
	tween.tween_property(bumper, "scale", Vector3.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE).from(Vector3(1.4, 1, 1.4))
	tween.parallel().tween_property(bumper.material_overlay, "albedo_color", Color.TRANSPARENT, 0.4).from(Color.RED)
