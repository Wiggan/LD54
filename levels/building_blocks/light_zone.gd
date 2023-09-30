extends Node3D

@onready var omni_light_3d = $OmniLight3D
@onready var collision_shape_3d = $Area3D/CollisionShape3D

@export var start_radius = 20.0
@export var step_count = 10
@export var step_duration = 0.5
@export var step_delay = 3



# Called when the node enters the scene tree for the first time.
func _ready():
	update_directional_shadows()
	var step_size = start_radius / step_count
	var tween = create_tween()
	for i in range(step_count-1):
		tween.tween_method(set_radius, 
					start_radius - i * step_size, 
					start_radius - (i + 1) * step_size,
					step_duration).set_delay(step_delay).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

func set_radius(radius):
	omni_light_3d.omni_range = radius
	collision_shape_3d.shape.radius = radius

func update_directional_shadows():
	for shadow in get_tree().get_nodes_in_group("DirectionalShadow"):
		shadow.light_position = global_position
