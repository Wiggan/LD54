extends Control

signal paused
signal unpaused
signal game_saved

@onready var game_over_screen = $GameOverScreen
const GAME_OVER_TEXT = """[center]You held of the intruders for %d seconds but were ultimately overrun.

Better luck next time![/center]"""

#  Upgrades
const BOOST1 = {"name": "Boost +1"}
const BOOST2 = {"name": "Boost +2"}
const BOOST3 = {"name": "Boost +3"}
const SPEED1 = {"name": "Speed +1"}
const SPEED2 = {"name": "Speed +2"}
const SPEED3 = {"name": "Speed +3"}
const DEFENSE1 = {"name": "Defense +1"}
const DEFENSE2 = {"name": "Defense +2"}
const DEFENSE3 = {"name": "Defense +3"}
const HEALTH1 = {"name": "Health +1"}
const HEALTH2 = {"name": "Health +2"}
const HEALTH3 = {"name": "Health +3"}

const UPGRADE_TABLES = {
	12: [BOOST3, SPEED3, DEFENSE3, HEALTH3],
	9: [BOOST3, SPEED3, DEFENSE3, HEALTH3, BOOST2, SPEED2, DEFENSE2, HEALTH2],
	5: [BOOST2, SPEED2, DEFENSE2, HEALTH2],
	2: [BOOST1, SPEED1, DEFENSE1, HEALTH1, BOOST2, SPEED2, DEFENSE2, HEALTH2],
	0: [BOOST1, SPEED1, DEFENSE1, HEALTH1],
}

var game_state = get_default_game_state()

enum State {MainMenu, Game, Score}
var state

func _unhandled_input(event):
	if event.is_action_pressed("ui_menu"):
		if get_tree().paused:
			unpause()
		else:
			pause()
	elif event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			unpause()
			
func unpause():
	if state == State.Game:
		get_tree().paused = false
		unpaused.emit()
	
func pause():
	get_tree().paused = true
	paused.emit()
	
func game_over():
	get_tree().paused = true
	Cursor.show_cursor()
	Transition.fade_and_call(show_game_over_screen)
	AudioManager.play_song(AudioManager.Song.SCORE, true, 2)

func show_game_over_screen():
	state = State.Score
	$GameOverScreen/VBoxContainer/PanelContainer/RichTextLabel.text = GAME_OVER_TEXT % game_state["Time"]
	game_over_screen.set_visible(true)
	$GameOverScreen/VBoxContainer/RetryButton.grab_focus()
	
	
func get_default_game_state():
	return {
		"score": 0,
		"rounds_played": 0,
		"inventory": {
			"slot1": {"name": "Boost +1"},
			"slot2": null,
			"slot3": null,
			"offer": {"name": "Boost +2"},
		}
	}

	
func restart(reset=true):
	if reset:
		game_state = get_default_game_state()
		save_game()
	else:
		load_game()
	state = State.Game
	Cursor.hide_cursor()
	#Transition.fade_and_call(Transition.load_level.bind(ProjectSettings["application/run/main_scene"]))
	Transition.fade_and_call(Transition.load_level.bind("res://game/Levels/home/home.tscn"))
	get_tree().paused = false


const FILE_NAME = "user://game.save"
const SECTION = "Save"
var save_file = ConfigFile.new()

func _ready():
	#print(GameManager.UPGRADE_TABLES)
	var result = save_file.load(FILE_NAME)
	if result == OK:
		print("Found save file")
	else:
		print("No save file found")
		
func save_game():
	print("Saving game")
	save_file.set_value(SECTION, "game_state", game_state)
	save_file.save(FILE_NAME)
	game_saved.emit()
	
	
func load_game():
	if save_file.has_section_key(SECTION, "game_state"):
		game_state = save_file.get_value(SECTION, "game_state")
		print("Loaded save from file")
	else:
		print("No save available")
	
func has_saved_game():
	return save_file.has_section(SECTION)
