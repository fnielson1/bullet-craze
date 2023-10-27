extends Node2D

@onready var _flySfx = $FlySfx


func play_death_sfx() -> void:
	$DeathSfx.play()
	
func play_fly_sfx() -> void:
	if not _flySfx.playing:
		_flySfx.play()
