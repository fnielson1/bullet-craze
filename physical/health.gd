extends Node

@export var health = 100


func on_hit(dmg: int) -> bool:
	health -= dmg
	
	return health <= 0
