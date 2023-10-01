extends Area3D
@onready var boost_sfx = $BoostSFX

const BOOST_AMOUNT = 7

func _on_body_entered(body: RigidBody3D):
	body.apply_central_impulse(Vector3.FORWARD * global_transform * BOOST_AMOUNT)
	boost_sfx.play()
