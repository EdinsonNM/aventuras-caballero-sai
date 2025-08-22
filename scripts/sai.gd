extends CharacterBody2D

const SPEED = 80.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _frames: SpriteFrames = _animated_sprite.sprite_frames

var is_facing_right := true
var is_attacking := false   # <-- NUEVO

func _ready() -> void:
	add_to_group("jugador")
	# Asegura que "peleando" no haga loop
	if _frames.has_animation("peleando"):
		_frames.set_animation_loop("peleando", false)
	# Conecta el final de animación
	_animated_sprite.animation_finished.connect(_on_animation_finished)

func updateAnimations(direction):
	if not is_on_floor():
		if velocity.y < 0:
			_animated_sprite.play("saltando")
		else:
			_animated_sprite.play("cayendo")
	else:
		if direction != 0:
			_animated_sprite.play("caminando")
		else:
			_animated_sprite.play("default")

func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")

	# ATACAR (solo si no estamos ya atacando)
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		$AttackArea.monitoring = true   # habilita el área
		velocity.x = 0              # opcional: parar al atacar
		_animated_sprite.play("peleando")
		print("attacking..." )
	else:
		# Mientras ataca, no cambiamos la animación
		if not is_attacking:
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			flip()
			updateAnimations(direction)

	move_and_slide()

func _on_animation_finished():
	# Solo liberamos el estado si terminó "peleando"
	if _animated_sprite.animation == "peleando":
		is_attacking = false
		$AttackArea.monitoring = false
		print("end attack")
		
func is_attacking_now():
	return is_attacking
