extends Button

func _can_drop_data(_at_position, data):
	var slot_name = data["name"]
	if GameManager.game_state["inventory"][slot_name]:
		return true
	return false
	
func _drop_data(_at_position, data):
	var slot_name = data["name"]
	var temp = GameManager.game_state["inventory"][name]
	GameManager.game_state["inventory"][name] = GameManager.game_state["inventory"][slot_name]
	GameManager.game_state["inventory"][slot_name] = temp
	
	var other = get_tree().root.get_node(data["path"])
	temp = other.text
	other.text = text
	text = temp

func _get_drag_data(_at_position):
	if GameManager.game_state["inventory"][name]:
		var content = self.duplicate()
		var center_container = Control.new()
		center_container.add_child(content)
		content.set_position(-0.5 * content.custom_minimum_size)
		set_drag_preview(center_container)
	return {"path": get_path(), "name": name}
