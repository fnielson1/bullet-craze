class_name BulletScript extends RigidBody2D


static var BulletScene = preload("res://weapons/bullet.tscn")
var velocity = Vector2(0,0)
var shooter_id = -1

@onready var _timer = $TimeToLive
@onready var _damageNode = $Damage


static func shoot(shooter_id: int, current_scene: Node, spawn_transform: Transform2D, velocity_arg: Vector2) -> BulletScript:
	var bullet = BulletScene.instantiate()
	current_scene.add_child(bullet)
	bullet.shooter_id = shooter_id
	bullet.transform = spawn_transform
	bullet.velocity = velocity_arg
	return bullet


func set_time_to_live(value: int) -> void:
	_timer.stop()
	_timer.wait_time = value
	_timer.start()


func _ready() -> void:
	_timer.timeout.connect(_on_time_to_live_done)
	_timer.start()

	
func _on_time_to_live_done() -> void:
	_timer.stop()
	queue_free()


func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		_process_collision_info(collision_info)
		

func _process_collision_info(collision_info: KinematicCollision2D) -> void:
	if _damageNode.on_hit(shooter_id, collision_info):
		queue_free()
	else:
		velocity = velocity.bounce(collision_info.get_normal())

