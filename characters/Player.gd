extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATE_SPEED = SPEED / 20
const DECELERATE_SPEED = SPEED / 30

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	# Handle Jump.
	if Input.is_action_pressed("ui_up"):
		velocity.y = move_toward(velocity.y, -SPEED, ACCELERATE_SPEED)
	elif Input.is_action_pressed("ui_down"):
		velocity.y = move_toward(velocity.y, SPEED, ACCELERATE_SPEED)
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATE_SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATE_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATE_SPEED)

	move_and_slide()
