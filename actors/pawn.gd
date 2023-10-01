class_name Pawn
extends RigidBody3D

const MAX_CHARGE_TIME = 1.0

signal collided_with_pawn
signal released_attack
signal died
@onready var explosion_scene = preload("res://actors/actor_components/explosion.tscn")
@onready var directional_stuff = $DirectionalStuff
@onready var charge_indicator = $DirectionalStuff/ChargeIndicator
@onready var mesh_instance_3d = $MeshInstance3D
@onready var health_bar = $health_bar
@onready var health = $Health

# SFX
@onready var moving_sfx = $MovingSFX
@onready var start_charge_sfx = $StartChargeSFX
@onready var stop_charge_sfx = $StopChargeSFX
@onready var hit_sfx = $HitSFX


@export var target = Vector3.FORWARD:
	set(value):
		target = value
		directional_stuff.look_at(target)
		directional_stuff.rotation *= Vector3(0, 1, 0)
@export var overlay: StandardMaterial3D
@export var mesh: Mesh
@export var directional_force = 9
@export var max_impulse = 7
@export var damping_on_charge = 0.4
@export var hp = 100.0:
	set(value):
		hp = value
		if is_instance_valid(health):
			health.max_health = value

var charging = false
var charge_time = 0.0


func start_charging():
	if not charging:
		charging = true
		charge_time = 0.0
		charge_indicator.visible = true
		linear_damp = damping_on_charge
		start_charge_sfx.play()
	
func stop_charging():
	if charging:
		charging = false
		charge_indicator.visible = false
		var impulse = directional_stuff.transform * Vector3.FORWARD * charge_time * max_impulse
		apply_central_impulse(impulse)
		linear_damp = 0.1
		released_attack.emit()
		stop_charge_sfx.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	health.max_health = hp
	mesh_instance_3d.mesh = mesh
	mesh_instance_3d.material_override = overlay
	moving_sfx.seek(randf_range(0, moving_sfx.stream.get_length()))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_moving_sfx()
	if charging:
		charge_time = minf(charge_time + delta, MAX_CHARGE_TIME)
		charge_indicator.scale = Vector3(1, 1, charge_time)

func _update_moving_sfx():
	moving_sfx.volume_db = lerp(-18, -10, linear_velocity.length()/7)
	moving_sfx.pitch_scale = lerp(0.6, 1.4, linear_velocity.length()/7)
	

func _physics_process(_delta):
	var force = directional_stuff.transform * Vector3.FORWARD * directional_force
	apply_central_force(force)

func _on_health_damage_taken(new_health):
	health_bar.reduce_to(new_health / health.max_health * 100)

func _on_health_died():
	var explosion = explosion_scene.instantiate()
	explosion.emitting = true
	explosion.set_deferred("global_position", global_position)
	add_sibling(explosion)
	
	var tween = create_tween()
	tween.tween_callback(queue_free).set_delay(0.5)
	health_bar.reduce_to(0)
	died.emit()
	
func _on_health_healed(new_health):
	health_bar.add_to(new_health / health.max_health * 100)


func _on_body_entered(body):
	var speed = linear_velocity.length()
	if not hit_sfx.playing and speed > 3:
		hit_sfx.volume_db = lerp(-9, 0, speed/7)
		hit_sfx.play()
	
	if body.is_in_group("Wall"):
		body.pawn_collided(speed, self)
	elif body.is_in_group("Pawns"):
		collided_with_pawn.emit()
