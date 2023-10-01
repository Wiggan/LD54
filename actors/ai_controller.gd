extends Node3D
@onready var pawn: Pawn = $Pawn
@onready var ray_cast_3d = $Pawn/RayCast3D
@onready var label_3d = $Pawn/Label3D
@onready var cooldown = $Cooldown
@onready var navagent = $Pawn/NavigationAgent3D


const UPDATE_INTERVAL = 7
const ATTACK_TRIGGER_DISTANCE = 3
const ATTACK_OVER_SPEED = 1.5
const DEFEND_SPEED_THRESHOLD = 7
const DARKNESS_MARGIN = 1
const TIME_SPENT_IN_STATE_THRESHOLD = 4

var light
var player

# State variables
var distance_from_light
var distance_from_player
var light_radius
var speed
var can_see_player
var hiding_place
var frames_since_last_update = randi_range(0, UPDATE_INTERVAL)
var time_spent_in_state = 0

enum State {
	AvoidingDarkness,
	Attacking,
	Defending,
	Hiding
}

var process_state = {
	State.AvoidingDarkness: process_avoiding_darkness,
	State.Attacking: process_attacking,
	State.Defending: process_defending,
	State.Hiding: process_hiding,
}
var enter_state = {
	State.AvoidingDarkness: enter_avoiding_darkness,
	State.Attacking: enter_attacking,
	State.Defending: enter_defending,
	State.Hiding: enter_hiding,
}

var state = State.AvoidingDarkness

# Called when the node enters the scene tree for the first time.
func _ready():
	light = get_tree().get_nodes_in_group("Light").front()
	player = get_tree().get_nodes_in_group("PlayerPawn").front()

func _get_ray_hits_player():
	ray_cast_3d.look_at(player.global_position)
	ray_cast_3d.force_raycast_update()
	if ray_cast_3d.is_colliding():
		var collided_layer = ray_cast_3d.get_collider().collision_layer
		return collided_layer & 2
	return false

func _get_wants_to_change_state():
	if state == State.Attacking:
		if not pawn.charging and speed < ATTACK_OVER_SPEED:
			#print("Attack is over, change state")
			return true
			
	if (state != State.Attacking and 
		state != State.Defending and 
		speed > DEFEND_SPEED_THRESHOLD):
			#print("Going very fast, not defending, change state")
			return true
		
	if (state != State.AvoidingDarkness and 
		state != State.Defending and
		distance_from_light > light_radius - DARKNESS_MARGIN):
		#print("Too close to darkness, change state")
		return true
		
	if ((state == State.AvoidingDarkness or 
		state == State.Defending) and
		distance_from_light < DARKNESS_MARGIN):
		#print("Too safe, change state")
		return true
		
	if state != State.Attacking and player.global_position.distance_to(light.global_position) > light_radius - DARKNESS_MARGIN:
		#print("Good chance to attack player, change state")
		return true
		
	if (state != State.Hiding and 
		time_spent_in_state > TIME_SPENT_IN_STATE_THRESHOLD):
		#print("Too long in same state, change state")
		return true
		
	if time_spent_in_state > TIME_SPENT_IN_STATE_THRESHOLD * 3:
		#print("Too long in same state, change state")
		return true

func _pick_new_state():
	if distance_from_light > light_radius:
		return State.AvoidingDarkness
	
	if distance_from_light < light_radius and speed > DEFEND_SPEED_THRESHOLD:
		if cooldown.time_left == 0:
			return State.Defending
		else:
			return State.AvoidingDarkness
			
	# Let's not be too strict about cooldown...
	if cooldown.time_left == 0:
		if can_see_player and distance_from_player < ATTACK_TRIGGER_DISTANCE:
			return State.Attacking
		
		if player.global_position.distance_to(light.global_position) > light_radius - DARKNESS_MARGIN:
			return State.Attacking
		
	#print("Picking random state")
	return State.values().pick_random()

func _change_state(new_state):
	time_spent_in_state = 0
	pawn.stop_charging()
	state = new_state
	enter_state[state].call()

func _update_state():
	distance_from_light = pawn.global_position.distance_to(light.global_position)
	distance_from_player = pawn.global_position.distance_to(player.global_position)
	light_radius = light.radius
	speed = pawn.linear_velocity.length()
	ray_cast_3d.position = Vector3(0, 0.3, 0)
	can_see_player = _get_ray_hits_player()
	
	if _get_wants_to_change_state():
		var new_state = _pick_new_state()
		_change_state(new_state)
	
	label_3d.text = str(State.keys()[state]) + " " + str(round(speed))
	if can_see_player:
		label_3d.modulate = Color.GREEN
	else:
		label_3d.modulate = Color.WHEAT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player) and is_instance_valid(pawn) and pawn.health.alive:
		frames_since_last_update += 1
		time_spent_in_state += delta
		if frames_since_last_update >= UPDATE_INTERVAL:
			frames_since_last_update = 0
			_update_state()
			process_state[state].call()
	
func enter_avoiding_darkness():
	process_avoiding_darkness()
func process_avoiding_darkness():
	navagent.target_position = light.global_position
	pawn.target = navagent.get_next_path_position()

func enter_attacking():
	pawn.start_charging()
	pawn.target = player.global_position
func process_attacking():
	pawn.target = player.global_position
	if (pawn.charging and
		pawn.charge_time > 0.6 and 
		distance_from_player < ATTACK_TRIGGER_DISTANCE):
		#print("Releasing attack!")
		pawn.stop_charging()
	
func enter_defending():
	pawn.start_charging()
	hiding_place = _find_hiding_place()
	if not hiding_place:
		#print("Found no good hiding place")
		hiding_place = light.global_position
	process_defending()
func process_defending():
	navagent.target_position = light.global_position
	pawn.target = navagent.get_next_path_position()
	
func enter_hiding():
	hiding_place = _find_hiding_place()
	if not hiding_place:
		#print("Found no good hiding place")
		hiding_place = light.global_position
	process_hiding()
func process_hiding():
	navagent.target_position = hiding_place
	pawn.target = navagent.get_next_path_position()

func _find_hiding_place():
	var potential_hiding_places = get_tree().get_nodes_in_group("HidingPlace")
	if not potential_hiding_places.is_empty():
		for i in range(10):
			var potential_hiding_place = potential_hiding_places.pick_random()
			ray_cast_3d.global_position = potential_hiding_place.global_position
			if (not _get_ray_hits_player() and 
				potential_hiding_place.global_position.distance_to(light.global_position) < light_radius):
				return potential_hiding_place.global_position


func _on_pawn_released_attack():
	cooldown.start()


func _on_pawn_died():
	pass # Replace with function body.
