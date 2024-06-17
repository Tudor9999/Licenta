extends Node2D

@export var final = false

func activate():
	if final:
		GameManager.win()

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		activate()
