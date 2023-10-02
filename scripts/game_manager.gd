extends Node

static var _is_level_end = true

static var _endLevelOverlayScene = preload('res://overlays/end_level_overlay.tscn')


func show_end_level_overlay(success: bool) -> void:
	var overlay = _endLevelOverlayScene.instantiate()
	overlay.set_title('Winner!')
	get_tree().current_scene.add_child(overlay)
