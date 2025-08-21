extends Area2D

func _on_body_entered(body):
	$AnimationPlayer.play("pickup")
	#queue_free()
 
