extends CharacterBody2D


@export var BULLET_VELOCITY_SCALE = 600
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var ACCELERATE_SPEED = SPEED / 20
var DECELERATE_SPEED = SPEED / 30

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var BulletScene = preload("res://weapons/bullet.tscn")

@onready var _anim = $AnimationPlayer
@onready var _bulletSpawn = $PlayerSprite/BulletSpawn
@onready var _healthNode = $Health
@onready var _collisionShape = $CollisionShape2D


func _ready() -> void:
	SignalManager.global_gui_input.connect(_handle_input)


func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	

func _handle_input(event: InputEvent) -> void:
	var buttonPress = Input.is_action_just_released('ui_primary_action')
	if buttonPress:
		_shoot()
	
	
func _shoot() -> void:
	var current_scene = get_tree().current_scene
	var radians = get_angle_to(get_global_mouse_position())

	var velocity_local = Vector2(cos(radians) * BULLET_VELOCITY_SCALE, sin(radians) * BULLET_VELOCITY_SCALE); # scale for speed
	var bullet = BulletScript.shoot(get_instance_id(), current_scene, _bulletSpawn.global_transform, velocity_local)
	bullet.set_collision_mask_value(Globals.ENEMY_LAYER, true)
	

func on_hit(shooter_id: int, dmg: int) -> bool:
	if shooter_id == get_instance_id():
		return false;
		
	if _healthNode.on_hit(dmg):
		_anim.play("Death")
		GameManager.show_end_level_overlay(false)
		return true
	else:
		_anim.play("OnHit")
		return false


func _handle_movement(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		velocity.y = move_toward(velocity.y, -SPEED, ACCELERATE_SPEED)
		if not _anim.is_playing():
			_anim.play("Up")
	elif Input.is_action_pressed("ui_down"):
		velocity.y = move_toward(velocity.y, SPEED, ACCELERATE_SPEED)
		if not _anim.is_playing():
			_anim.play("Down")
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATE_SPEED)
		if not _anim.is_playing():
			_anim.play("Idle")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATE_SPEED)
		if not _anim.is_playing():
			_anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATE_SPEED)
		if velocity.y == 0 and not _anim.is_playing():
			_anim.play("Idle")
			
	_set_look_direction()
	move_and_slide()


func _set_look_direction() -> void:
	# Make the sprite look left or right depending on where the mouse is
	var angle = get_angle_to(get_global_mouse_position())
	angle = snappedf(angle, 0.01)
	if angle <= -1.55 or angle >= 1.65:
		self.scale.x = -1
	else:
		self.scale.x = 1
