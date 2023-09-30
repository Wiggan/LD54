class_name Pawn
extends RigidBody3D

const MAX_CHARGE_TIME = 1.0
const MAX_IMPULSE = 5
const CONSTANT_FORCE = 3

@onready var directional_stuff = $DirectionalStuff
@onready var charge_indicator = $DirectionalStuff/ChargeIndicator

@export var target = Vector3.ZERO:
	set(value):
		target = value
		directional_stuff.look_at(target)
		directional_stuff.rotation *= Vector3(0, 1, 0)

var charging = false
var charge_time = 0.0

func start_charging():
	charging = true
	charge_time = 0.0
	charge_indicator.visible = true
	linear_damp = 0.5
	
func stop_charging():
	charging = false
	charge_indicator.visible = false
	var impulse = directional_stuff.transform * Vector3.FORWARD * charge_time * MAX_IMPULSE
	apply_central_impulse(impulse)
	linear_damp = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if charging:
		charge_time = minf(charge_time + delta, MAX_CHARGE_TIME)
		charge_indicator.scale = Vector3.ONE * charge_time

func _physics_process(_delta):
	var force = directional_stuff.transform * Vector3.FORWARD * CONSTANT_FORCE
	print(force)
	apply_central_force(force)
