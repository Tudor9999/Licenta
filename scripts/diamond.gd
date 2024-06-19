extends Area2D
@onready var audio_stream_player = $AudioStreamPlayer


func _on_area_entered(area):
	if area.get_parent() is Player:
		audio_stream_player.play()
		await audio_stream_player.finished
		GameManager.gain_diamonds(1)
		GameManager.score += 75 * GameManager.dificulty
		queue_free()
