extends Area2D

@onready var timer= $Timer
func _on_body_entered(body):
	if(body.is_in_group("jugador") && body.is_attacking_now()):
		_kill_owner()
		print("es jugador...")
		return
	if(owner.is_in_group("enemigos")):
		print("se choco con un enemigo")	
	print("you are died!")
	Engine.time_scale=0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout():
	Engine.time_scale=1
	get_tree().reload_current_scene()


var player_ref: Node = null  # guardamos referencia si el jugador está dentro



func _kill_owner() -> void:
	var owner_node := get_parent()
	if owner_node and owner_node.has_method("die"):
		owner_node.call_deferred("die")
		owner_node.queue_free()
	else:
		owner_node.queue_free()
