extends RigidBody2D

var velocity = Vector2(0,0)


func _ready() -> void:
	$TimeToLive.timeout.connect(_on_time_to_live_done)
	$TimeToLive.start()
	
func _on_time_to_live_done() -> void:
	$TimeToLive.stop()
	queue_free()

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())


func _on_body_entered(body) -> void:
	print('collision with ' + body.name) # Replace with function body.
