extends Node

signal diamonds_gained(int)

var diamonds = 0
var player : Player
var paused = false
var pause_menu

func gain_diamonds(gained_diamonds):
	diamonds += gained_diamonds
	emit_signal("diamonds_gained", gained_diamonds)
	print(diamonds)

func pause_game():
	paused = !paused
	
	pause_menu.visible = paused

func resume():
	get_tree().paused = false
	pause_game()

func restart():
	diamonds = 0
	get_tree().reload_current_scene()

func levels():
	pass

func quit():
	get_tree().quit()
