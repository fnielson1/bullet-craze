extends Node2D

@export var BULLET_VELOCITY_SCALE = 600
@export var NORMAL_ATTACK_SPEED = 0.5
@export var FAST_ATTACK_SPEED = 0.1
var _player: CharacterBody2D
var _attackTarget: Object
var _instanceIdToIgnore: int


@onready var _attackTimer = $AttackTimer
@onready var _detectPlayerRayCast = $DetectPlayer

func setup(instanceIdToIgnore: int) -> void:
	_instanceIdToIgnore = instanceIdToIgnore


func _ready() -> void:
	_attackTimer.timeout.connect(_shoot)
	_player = get_tree().get_first_node_in_group(Globals.PLAYER_GROUP)
	_detectPlayerRayCast.global_position = get_parent().global_position


func _physics_process(delta: float) -> void:
	_detectPlayerRayCast.target_position = Vector2(_player.global_position) - _detectPlayerRayCast.global_position
	if _detectPlayerRayCast.is_colliding():
		var collider = _detectPlayerRayCast.get_collider()
		var isPlayer = collider.is_in_group(Globals.PLAYER_GROUP)
		if isPlayer:
			_begin_attack(collider)
		else:
			_end_attack()
			
				
func _begin_attack(collider: Object) -> void:
	if _attackTarget == null:
		_shoot() # Fire immediately first
		_attackTarget = collider;
		_attackTimer.start()
	
	
func _end_attack() -> void:
	if _attackTarget != null:
		_attackTarget = null
		_attackTimer.stop()
	

func _shoot() -> void:
	if _attackTarget:
		var current_scene = get_tree().current_scene
		var radians = get_angle_to(_attackTarget.global_position)
		
		var velocity_local = Vector2(cos(radians) * BULLET_VELOCITY_SCALE, sin(radians) * BULLET_VELOCITY_SCALE); # scale for speed
		var bullet = BulletScript.shoot(_instanceIdToIgnore, current_scene, self.global_transform, velocity_local)
		bullet.set_time_to_live(5)
		bullet.set_collision_mask_value(Globals.PLAYER_LAYER, true)


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group(Globals.PLAYER_GROUP):
		_set_fast_attack(true)


func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group(Globals.PLAYER_GROUP):
		_set_fast_attack(false)
		

func _set_fast_attack(value: bool) -> void:
	if value:
		_attackTimer.wait_time = FAST_ATTACK_SPEED
	else:
		_attackTimer.wait_time = NORMAL_ATTACK_SPEED
