extends Control
@onready var menu_ui = $MenuUI

@onready var background_level_loader = preload("res://transition/background_level_loader.tscn")
@onready var black = $"CanvasLayer/Black"

var callback: Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_ui.hide()
	GameManager.connect("paused", show_menu)
	GameManager.connect("unpaused", hide_menu)

func hide_menu():
	var tween = create_tween()
	tween.tween_property(menu_ui, "modulate", Color.TRANSPARENT, 0.4).from(Color.WHITE)
	tween.tween_callback(menu_ui.hide)
	#AudioManager.play_song(AudioManager.Song.GAME)

func show_menu():
	menu_ui.show()
	var tween = create_tween()
	tween.tween_property(menu_ui, "modulate", Color.WHITE, 1).from(Color.TRANSPARENT)
	
	#AudioManager.play_song(AudioManager.Song.MENU)

func fade_and_call(callable):
	var fade_tween = create_tween()
	black.show()
	fade_tween.tween_property(black.material, "shader_parameter/fader", 1.0, 1.2)
	fade_tween.tween_callback(callable)
	fade_tween.tween_property(black.material, "shader_parameter/fader", 0.0, 1.2)
	fade_tween.tween_callback(black.hide)
