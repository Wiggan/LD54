@tool
extends Node3D
@onready var sprite_3d = $Sprite3D

@export var size = 1.0:
	set(value):
		size = value
		call_deferred("update_size")

func update_size():
	sprite_3d.scale = Vector3.ONE * size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
