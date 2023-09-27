extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATE_SPEED = SPEED / 20
const DECELERATE_SPEED = SPEED / 30

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimationPlayer
@onready var playerSpriteWidth: float
@onready var playerSpriteHeight: float


func _ready() -> void:
	playerSpriteWidth = 13
	playerSpriteHeight = 23


func _physics_process(delta: float) -> void:
	
	# Handle Jump.
	if Input.is_action_pressed("ui_up"):
		velocity.y = move_toward(velocity.y, -SPEED, ACCELERATE_SPEED)
		anim.play("Up")
	elif Input.is_action_pressed("ui_down"):
		velocity.y = move_toward(velocity.y, SPEED, ACCELERATE_SPEED)
		anim.play("Down")
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATE_SPEED)
		anim.play("Idle")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATE_SPEED)
		anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATE_SPEED)
		if velocity.y == 0:
			anim.play("Idle")
			
	_set_look_direction()
	_keep_character_on_screen()

	move_and_slide()
	
func _set_look_direction() -> void:
	# Make the sprite look left or right depending on where the mouse is
	var angle = get_angle_to(get_global_mouse_position())
	if angle < -1.5 or angle > 1.5:
		$PlayerSprite.flip_h = true
	else:
		$PlayerSprite.flip_h = false
		
func _keep_character_on_screen() -> void:
	var screensize = get_viewport().size
	position.x = clamp(position.x, 0 + playerSpriteWidth, screensize.x - playerSpriteWidth)
	position.y = clamp(position.y, 0 + playerSpriteHeight, screensize.y - playerSpriteHeight)
