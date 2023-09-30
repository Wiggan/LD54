@tool
extends Node3D
@onready var sprite_3d = $Sprite3D

@export var light_position = Vector3.ONE:
	set(value):
		light_position = value
		if is_instance_valid(sprite_3d):
			sprite_3d.look_at(light_position, Vector3.UP, true)
			sprite_3d.rotation *= Vector3(0, 1, 0)

@export var shadow_width: float = 1.0:
	set(value):
		shadow_width = value
		if is_instance_valid(sprite_3d):
			sprite_3d.scale = Vector3(shadow_width, 1, 1)

func _ready():
	sprite_3d.look_at(light_position, Vector3.UP, true)
	sprite_3d.rotation *= Vector3(0, 1, 0)
	sprite_3d.scale = Vector3(shadow_width, 1.0, 1.0)
	

