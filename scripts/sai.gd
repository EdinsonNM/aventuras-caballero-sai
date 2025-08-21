extends CharacterBody2D


const SPEED = 80.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _animated_sprite=$AnimatedSprite2D

var is_facing_right=true;
func updateAnimations(direction):
	if not is_on_floor():
		if(velocity.y<0):
			_animated_sprite.play("saltando")
		else:
			_animated_sprite.play("cayendo")
	else:
		if direction != 0:
			_animated_sprite.play("caminando")
		else:
			_animated_sprite.play("default")

		
func  flip():
	if(is_facing_right and velocity.x<0) or(not is_facing_right and velocity.x>0):
		scale.x *= -1
		is_facing_right = not is_facing_right
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	flip()
	updateAnimations(direction)
	move_and_slide()
