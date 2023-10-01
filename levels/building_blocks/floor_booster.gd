extends Area3D
@onready var boost_sfx = $BoostSFX

const BOOST_AMOUNT = 7
signal boosted_pawn

func _on_body_entered(body: RigidBody3D):
	body.apply_central_impulse(global_transform.basis.z * BOOST_AMOUNT)
	boost_sfx.play()
	boosted_pawn.emit()
