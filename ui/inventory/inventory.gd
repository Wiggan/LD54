extends Control
@onready var inventory = $CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Inventory
@onready var offer = $CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer
var slot_scene = preload("res://ui/inventory/inventory_slot.tscn")
@onready var ok_button = $CenterContainer/Button


func _ready():
	for slot_name in GameManager.game_state["inventory"]:
		var new_slot = slot_scene.instantiate()
		if GameManager.game_state["inventory"][slot_name]:
			new_slot.text = GameManager.game_state["inventory"][slot_name]["name"]
		new_slot.name = slot_name
		if "slot" in slot_name:
			inventory.add_child(new_slot)
		else:
			offer.add_child(new_slot)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.6).from(Color.TRANSPARENT)

func _on_button_pressed():
	get_tree().paused = false
	ok_button.disabled = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.6).from(Color.WHITE)
