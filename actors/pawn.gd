class_name Pawn
extends RigidBody3D

const MAX_CHARGE_TIME = 1.0
const MAX_IMPULSE = 7
const CONSTANT_FORCE = 9

signal released_attack

@onready var directional_stuff = $DirectionalStuff
@onready var charge_indicator = $DirectionalStuff/ChargeIndicator
@onready var mesh_instance_3d = $MeshInstance3D

@export var target = Vector3.ZERO:
	set(value):
		target = value
		directional_stuff.look_at(target)
		directional_stuff.rotation *= Vector3(0, 1, 0)
@export var overlay: StandardMaterial3D

var charging = false
var charge_time = 0.0


func start_charging():
	if not charging:
		charging = true
		charge_time = 0.0
		charge_indicator.visible = true
		linear_damp = 0.5
	
func stop_charging():
	if charging:
		charging = false
		charge_indicator.visible = false
		var impulse = directional_stuff.transform * Vector3.FORWARD * charge_time * MAX_IMPULSE
		apply_central_impulse(impulse)
		linear_damp = 0.1
		released_attack.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh_instance_3d.material_overlay = overlay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if charging:
		charge_time = minf(charge_time + delta, MAX_CHARGE_TIME)
		charge_indicator.scale = Vector3.ONE * charge_time

func _physics_process(_delta):
	var force = directional_stuff.transform * Vector3.FORWARD * CONSTANT_FORCE
	apply_central_force(force)
