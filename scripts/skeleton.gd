extends CharacterBody2D

@onready var skeleton = $"."
@onready var healthbar = $Sprite2D/EnemyHealthBar
@onready var ray_cast_2d = $RayCast2D
@onready var sprite_2d = $Sprite2D
@onready var animatable_body_2d = $AnimatableBody2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox = $HitBox/CollisionShape2D
@onready var ray_cast_2d_2 = $RayCast2D2
@onready var animation_player = $AnimationPlayer
@onready var attack_sound = $AttackSound

var health = 0
var max_health = 75
var take_damage = true
var hit = false
var can_attack = true
var dead = false
var speed = 60
var current_speed
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true
var attacking = false

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
		ray_cast_2d_2.position = Vector2(-21, -13)
		healthbar.position = Vector2(-29, -16)
		sprite_2d.offset = Vector2(0, 0)
		speed = abs(speed)
	else:
		collision_shape_2d.position = Vector2(21, -30)
		hitbox.position = Vector2(21, -30)
		ray_cast_2d.position = Vector2(38, -4)
		ray_cast_2d_2.position = Vector2(21, -13)
		healthbar.position = Vector2(15, -16)
		sprite_2d.offset = Vector2(41, 0)
		speed = abs(speed) * -1

func _ready():
	health = max_health
	healthbar.init_health(health)

func taking_damage(damage:int):
	if !dead:
		animation_player.play("hit")
		health -= damage
		healthbar._set_health(health)
		
		if health <= 0:
			die()

func _on_hit_box_area_entered(area):
	if area.get_parent() is Player && !dead && can_attack:
		animation_player.play("attack1")
		attack_sound.play()
		await get_tree().create_timer(0.7).timeout
		if area.get_parent() is Player && !dead && can_attack:
			area.get_parent().taking_damage(25 * GameManager.dificulty)
		animation_player.play("walk")

func get_hit():
	hit = !hit
	if hit:
		current_speed = speed
		speed = 0
		can_attack = false
	else:
		speed = current_speed
		can_attack = true
		animation_player.play("walk")

func die():
	GameManager.score += 100 * GameManager.dificulty
	dead = true
	current_speed = speed
	speed = 0
	animation_player.play("dead")
	await get_tree().create_timer(0.6).timeout
	speed = current_speed
	queue_free()
