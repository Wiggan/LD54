extends Control
@onready var button = $CenterContainer/VBoxContainer/Button
@onready var button_2 = $CenterContainer/VBoxContainer/HBoxContainer/Button2
@onready var button_3 = $CenterContainer/VBoxContainer/HBoxContainer/Button3
@onready var button_4 = $CenterContainer/VBoxContainer/HBoxContainer/Button4

@onready var buttons = [
	button,
	button_2,
	button_3,
	button_4,
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in buttons:
		button.toggled.connect(button_toggled)

func is_button_pressed(button):
	return button.button_pressed

func button_toggled(pressed):
	var pressed_buttons = buttons.filter(is_button_pressed)
	print(pressed_buttons.size())
	if pressed_buttons.size() == 2:
		var temp = pressed_buttons[0].text
		pressed_buttons[0].text = pressed_buttons[1].text
		pressed_buttons[1].text = temp
		pressed_buttons[0].button_pressed = false
		pressed_buttons[1].button_pressed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
