extends Node3D
var player
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("PlayerPawn").front()
	enemies = get_tree().get_nodes_in_group("EnemyPawn")
	player.died.connect(restart_current_level)
	for enemy in enemies:
		enemy.died.connect(enemy_died.bind(enemy))

func restart_current_level():
	AudioManager.level_lost.play()
	get_tree().reload_current_scene()

func enemy_died(enemy):
	enemies.erase(enemy)
	if enemies.size() == 0:
		AudioManager.level_cleared.play()
		print("WIN")

