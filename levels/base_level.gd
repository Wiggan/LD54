extends Node3D
var player
var enemies = []
@onready var navigation_region_3d = $NavigationRegion3D
var inventory_scene = preload("res://ui/inventory/inventory.tscn")
@export_file("*.tscn") var next_level: String

var match_ongoing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.state = GameManager.State.Game
	AudioManager.play_song(AudioManager.Song.GAME)
	navigation_region_3d.call_deferred("bake_navigation_mesh", true)
	player = get_tree().get_nodes_in_group("PlayerPawn").front()
	enemies = get_tree().get_nodes_in_group("EnemyPawn")
	player.died.connect(restart_current_level)
	for enemy in enemies:
		enemy.died.connect(enemy_died.bind(enemy))
	#on_round_ended(Transition.fade_and_call.bind(get_tree().reload_current_scene))


func on_round_ended(callable):
	match_ongoing = false
	GameManager.game_state["rounds_played"] += 1
	for limit in GameManager.UPGRADE_TABLES:
		if GameManager.game_state["rounds_played"] >= limit:
			GameManager.game_state["inventory"]["offer"] = GameManager.UPGRADE_TABLES[limit].pick_random()
			break
	var inv = inventory_scene.instantiate()
	call_deferred("add_child", inv)
	inv.get_node("CenterContainer/Button").pressed.connect(callable)


func restart_current_level():
	if match_ongoing:
		AudioManager.level_lost.play()
		on_round_ended(Transition.fade_and_call.bind(get_tree().reload_current_scene))

func enemy_died(enemy):
	if match_ongoing:
		enemies.erase(enemy)
		if enemies.is_empty():
			AudioManager.level_cleared.play()
			on_round_ended(Transition.fade_and_call.bind(get_tree().change_scene_to_file.bind(next_level)))
		


