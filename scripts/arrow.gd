extends Node2D
@onready var animation_player = $AnimationPlayer

var direction
var speed = -300.0
var lifetime = 2.0
var hit = false

func _ready():
	await get_tree().create_timer(lifetime).timeout
	die()

func _physics_process(delta):
	position.x += speed * delta * direction

func die():
	hit = true
	speed = 0
	animation_player.play("hit")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !hit:
		area.get_parent().taking_damage(25)
		die()
