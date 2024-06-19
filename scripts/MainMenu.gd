extends Node2D

@onready var easy = $CanvasLayer/Easy
@onready var medium = $CanvasLayer/Medium
@onready var hard = $CanvasLayer/Hard

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")


func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://scenes/Level2.tscn")


func _on_level_3_pressed():
	get_tree().change_scene_to_file("res://scenes/Level3.tscn")


func _on_easy_pressed():
	easy.button_pressed = true
	medium.button_pressed = false
	hard.button_pressed = false
	GameManager.dificulty = 1
	print(GameManager.dificulty)

func _on_medium_pressed():
	easy.button_pressed = false
	medium.button_pressed = true
	hard.button_pressed = false
	GameManager.dificulty = 2
	print(GameManager.dificulty)

func _on_hard_pressed():
	easy.button_pressed = false
	medium.button_pressed = false
	hard.button_pressed = true
	GameManager.dificulty = 3
	print(GameManager.dificulty)


func _on_button_pressed():
	GameManager.quit()
