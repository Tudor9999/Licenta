extends Node

signal diamonds_gained(int)

var diamonds = 0

func gain_diamonds(gained_diamonds):
	diamonds += gained_diamonds
	emit_signal("diamonds_gained", gained_diamonds)
	print(diamonds)
