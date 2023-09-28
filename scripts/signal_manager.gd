extends Control

signal _global_input
var global_gui_input = Signal(self, '_global_input')


# Called when the node enters the scene tree for the first time.
func _ready():
	# Make child be the first child in the scene to make event handling consistent
	# get_parent().move_child(self, 0) # Doesn't seem to work
	
	#Make the node span the entire screen
	set_global_position(Vector2(0, 0))
	var screensize = get_viewport().size
	set_size(Vector2(screensize.x, screensize.y))



func _on_gui_input(event):
	_global_input.emit(event)
