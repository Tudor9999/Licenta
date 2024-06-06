extends Area2D


func _on_body_entered(body):
	GameManager.gain_diamonds(1)
	queue_free()
