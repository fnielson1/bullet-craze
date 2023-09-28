extends CharacterBody2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	

	move_and_slide()


func _on_player_detection_body_entered(body):
	print(body.name)
