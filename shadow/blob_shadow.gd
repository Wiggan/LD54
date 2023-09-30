@tool
extends Node3D
@onready var sprite_3d = $Sprite3D

@export var size = 1.0:
	set(value):
		size = value
		if is_instance_valid(sprite_3d):
			sprite_3d.scale = Vector3.ONE * size
