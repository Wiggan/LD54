extends Control

func _ready():
	AudioManager.setup_buttons()


func _on_button_pressed():
	GameManager.restart()
