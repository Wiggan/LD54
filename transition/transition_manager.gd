extends Control

@onready var menu_animation = $Menu/MenuAnimation
@onready var menu = $Menu
@onready var background_level_loader = preload("res://transition/background_level_loader.tscn")
@onready var black = $Black

var callback: Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("paused", show_menu)
	GameManager.connect("unpaused", hide_menu)

func hide_menu():
	menu_animation.play("hide")
	AudioManager.play_song(AudioManager.Song.GAME)

func show_menu():
	menu_animation.play("show")
	AudioManager.play_song(AudioManager.Song.MENU)

func fade_and_call(callable):
	var fade_tween = create_tween()
	fade_tween.tween_property(black.material, "shader_parameter/lod", 10.0, 1.5)
	fade_tween.tween_callback(callable)
	fade_tween.tween_property(black.material, "shader_parameter/lod", 0.0, 0.5)
	
