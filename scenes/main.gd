extends Node2D


func _on_btn_play_button_up():
	get_tree().change_scene_to_file("res://scenes/level_select.tscn");

func _on_btn_quit_button_up():
	get_tree().quit()
