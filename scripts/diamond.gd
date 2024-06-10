extends Area2D


func _on_area_entered(area):
	if area.get_parent() is Player:
		GameManager.gain_diamonds(1)
		queue_free()
