extends Node


static var _endLevelOverlayScene = preload('res://overlays/end_level_overlay.tscn')


func show_end_level_overlay(success: bool) -> void:
	pause_game()
	var overlay = _endLevelOverlayScene.instantiate()
	if success:
		overlay.set_title('Winner!')
	get_tree().current_scene.add_child(overlay)
	
	
func pause_game():
	get_tree().paused = true

func unpause_game():
	get_tree().paused = false
