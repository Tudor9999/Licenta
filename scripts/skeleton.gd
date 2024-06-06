extends CharacterBody2D

@onready var skeleton = $"."
@onready var healthbar = $Sprite2D/EnemyHealthBar
@onready var ray_cast_2d = $RayCast2D
@onready var sprite_2d = $Sprite2D
@onready var animatable_body_2d = $AnimatableBody2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox = $HitBox/CollisionShape2D
@onready var ray_cast_2d_2 = $RayCast2D2

var health
var speed = 60
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !ray_cast_2d.is_colliding() && is_on_floor():
		flip()
	if ray_cast_2d_2.is_colliding():
		flip()
	
	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		collision_shape_2d.position = Vector2(-21, -30)
		hitbox.position = Vector2(-21, -30)
		ray_cast_2d.position = Vector2(-5, -4)
		ray_cast_2d_2.position = Vector2(-21, -24)
		healthbar.position = Vector2(-29, -16)
		sprite_2d.offset = Vector2(0, 0)
		speed = abs(speed)
	else:
		collision_shape_2d.position = Vector2(21, -30)
		hitbox.position = Vector2(21, -30)
		ray_cast_2d.position = Vector2(38, -4)
		ray_cast_2d_2.position = Vector2(21, -24)
		healthbar.position = Vector2(15, -16)
		sprite_2d.offset = Vector2(41, 0)
		speed = abs(speed) * -1

func _ready():
	health = 20
	healthbar.init_health(health)


func _on_hit_box_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().die()

func die():
	queue_free()
