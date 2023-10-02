extends CharacterBody2D


@onready var _anim = $AnimationPlayer
@onready var _healthNode = $Health
@onready var _collisionShape = $CollisionShape2D


func _physics_process(delta: float) -> void:
	move_and_slide()
	

func on_hit(dmg: int) -> bool:
	if _healthNode.on_hit(dmg):
		_anim.play("Death")
		_collisionShape.disabled = true # Don't have anything collide with us anymore
		GameManager.show_end_level_overlay(true)
		return true
	else:
		_anim.play("OnHit")
		return false


func _on_player_detection_body_entered(body):
	print(body.name)


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == 'Death':
		self.queue_free()
		
	elif anim_name == 'OnHit':
		_anim.play('Idle')
