extends Node


@export var damage = 10


func on_hit(collision_info: KinematicCollision2D) -> bool:
	var collider = collision_info.get_collider()
	
	if collider.has_method('on_hit'):
		var destroyed = collider.on_hit(damage)
		if destroyed:
			self.queue_free()
			return true
	return false
