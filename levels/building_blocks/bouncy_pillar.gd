extends "res://levels/building_blocks/base_pillar.gd"
@onready var bumper = $Bumper

const BOUNCYNESS = 1.5

func pawn_collided(speed, pawn: RigidBody3D):
	super(speed, pawn)
	var tween = create_tween()
	tween.tween_property(bumper, "scale", Vector3.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE).from(Vector3(1.4, 1, 1.4))
	tween.parallel().tween_property(bumper.material_overlay, "albedo_color", Color.TRANSPARENT, 0.4).from(Color.RED)
	pawn.apply_central_impulse((pawn.global_position - global_position).normalized() * speed * BOUNCYNESS)
