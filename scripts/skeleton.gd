extends Node2D

@onready var skeleton = $"."
@onready var healthbar = $EnemyHealthBar
var health

func _ready():
	health = 20
	healthbar.init_health(health)
