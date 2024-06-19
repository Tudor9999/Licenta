extends Node2D


@onready var animated_sprite_2d = $AnimatedSprite2D


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		animated_sprite_2d.play("spear")
		area.get_parent().taking_damage(15 * GameManager.dificulty)
