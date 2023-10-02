extends CanvasLayer



func set_title(title: String) -> void:
	$Message.text = title
	

func _on_level_select_button_up() -> void:
	get_tree().change_scene_to_file('res://scenes/level_select.tscn')


func _on_continue_button_up() -> void:
	pass # Replace with function body.


func _on_retry_button_up() -> void:
	var current_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_path)
