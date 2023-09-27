extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const SPEED_CHANGE_RATE = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	# Handle Jump.
	if Input.is_action_pressed("ui_up"):
		velocity.y = move_toward(velocity.y, -SPEED, SPEED_CHANGE_RATE)
	elif Input.is_action_pressed("ui_down"):
		velocity.y = move_toward(velocity.y, SPEED, SPEED_CHANGE_RATE)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED_CHANGE_RATE)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED_CHANGE_RATE)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_CHANGE_RATE)

	move_and_slide()
