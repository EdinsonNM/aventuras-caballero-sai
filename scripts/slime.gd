extends Node2D

const SPEED := 60
var direction := 1

@onready var ray_cast_left: RayCast2D  = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

var hp := 1
var dead := false

func _ready() -> void:
	add_to_group("enemigos")

func _process(delta: float) -> void:
	if dead:
		return

	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true

	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	position.x += direction * SPEED * delta

# ====== COMBATE ======

func take_damage(amount: int, from_pos: Vector2) -> void:
	if dead: 
		return
	hp -= amount

	# (Opcional) pequeño retroceso
	# var knock := sign(global_position.x - from_pos.x) * 30.0
	# position.x += knock

	if hp <= 0:
		die()
	else:
		# (Opcional) parpadeo de daño
		# _flash_hurt()
		pass

func die() -> void:
	dead = true
	set_process(false)                 # ya no camina
	#collider.set_deferred("disabled", true)

	if animated_sprite.sprite_frames.has_animation("dead"):
		animated_sprite.play("dead")
		animated_sprite.animation_finished.connect(func():
			if animated_sprite.animation == "dead":
				queue_free()
		)
	else:
		queue_free()

# (Opcional) parpadeo simple
func _flash_hurt() -> void:
	animated_sprite.modulate = Color(1,0.6,0.6)
	await get_tree().create_timer(0.08).timeout
	animated_sprite.modulate = Color(1,1,1)
