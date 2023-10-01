extends Node3D

@onready var omni_light_3d = $OmniLight3D
@onready var collision_shape_3d = $Area3D/CollisionShape3D
@onready var safe_area = $Area3D

@export var start_radius = 20.0
@export var step_count = 10
@export var step_duration = 0.5
@export var step_delay = 3

const DAMAGE = 10
signal shrinked

@export var radius = start_radius:
	set(value):
		radius = value
		omni_light_3d.omni_range = radius
		collision_shape_3d.shape.radius = radius
		

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = start_radius
	update_directional_shadows()
	var step_size = start_radius / step_count
	var tween = create_tween()
	for i in range(step_count-1):
		tween.tween_property(self, "radius", 
					start_radius - i * step_size,
					step_duration).set_delay(step_delay).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_callback(emit_signal.bind("shrinked"))

func update_directional_shadows():
	for shadow in get_tree().get_nodes_in_group("DirectionalShadow"):
		shadow.light_position = global_position


func _on_hurt_timer_timeout():
	for pawn in get_tree().get_nodes_in_group("Pawns"):
		if pawn not in safe_area.get_overlapping_bodies():
			pawn.get_node("Health").take_damage(DAMAGE)
