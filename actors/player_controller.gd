extends Node3D
@onready var cursor = $Cursor

@export var controlled_pawn: Pawn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if is_instance_valid(controlled_pawn):
		if event.is_action_pressed("charge"):
			controlled_pawn.start_charging()
		elif event.is_action_released("charge"):
			controlled_pawn.stop_charging()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var cursor_position = get_cursor_position()
	cursor.global_position = cursor_position
	if is_instance_valid(controlled_pawn):
		controlled_pawn.target = cursor_position
	
func get_cursor_position():
	var ground_plane  = Plane(Vector3(0, 1, 0))
	# Project a ray from camera, from where the mouse cursor is in 2D viewport
	var ray_length = 100000
	var mouse_position = get_viewport().get_mouse_position()
	var from = get_viewport().get_camera_3d().project_ray_origin(mouse_position)
	var to = from + get_viewport().get_camera_3d().project_ray_normal(mouse_position) * ray_length
	var cursor_position = ground_plane.intersects_ray(from, to)
	return cursor_position
