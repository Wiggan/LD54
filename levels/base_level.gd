extends Node3D
var player
var enemies = []
@onready var navigation_region_3d = $NavigationRegion3D

@export_file("*.tscn") var next_level: String

# Called when the node enters the scene tree for the first time.
func _ready():
	navigation_region_3d.call_deferred("bake_navigation_mesh", true)
	player = get_tree().get_nodes_in_group("PlayerPawn").front()
	enemies = get_tree().get_nodes_in_group("EnemyPawn")
	player.died.connect(restart_current_level)
	for enemy in enemies:
		enemy.died.connect(enemy_died.bind(enemy))

func restart_current_level():
	AudioManager.level_lost.play()
	Transition.fade_and_call(get_tree().reload_current_scene)

func enemy_died(enemy):
	enemies.erase(enemy)
	if enemies.is_empty():
		AudioManager.level_cleared.play()
		Transition.fade_and_call(get_tree().change_scene_to_file.bind(next_level))
		print("WIN")

