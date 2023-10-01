extends StaticBody3D
@onready var hit_sfx = $HitSFX

signal collided

func pawn_collided(speed, _pawn):
	collided.emit()
	if not hit_sfx.playing:
		hit_sfx.volume_db = lerp(-25, 3, speed/10)
		hit_sfx.play()
