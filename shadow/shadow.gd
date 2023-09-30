@tool
extends Node3D
@onready var sprite_3d = $Sprite3D

@export var light_position = Vector3.ONE:
	set(value):
		light_position = value
		call_deferred("update_light_position")

func _ready():
	update_light_position()

func update_light_position():
	sprite_3d.look_at(light_position, Vector3.UP, true)
	sprite_3d.rotation *= Vector3(0, 1, 0)

