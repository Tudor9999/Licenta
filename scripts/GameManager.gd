extends Node

signal diamonds_gained(int)

var diamonds = 0
var player : Player
var paused = false
var pause_menu
var final_screen
var score_label
var score : int = 0
var dificulty : int = 1

func gain_diamonds(gained_diamonds):
	diamonds += gained_diamonds
	emit_signal("diamonds_gained", gained_diamonds)
	print(diamonds)

func win():
	final_screen.visible = true
	score_label.text = "Score: " + str(score)

func pause_game():
	paused = !paused
	
	pause_menu.visible = paused

func resume():
	get_tree().paused = false
	pause_game()

func restart():
	diamonds = 0
	score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()

func levels():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func quit():
	get_tree().quit()
