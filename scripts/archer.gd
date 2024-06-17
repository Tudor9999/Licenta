extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var arrow = load("res://scenes/arrow.tscn")
@export var shooting : bool
var firerate = 2

@onready var animation_player = $AnimationPlayer
@onready var fire_point = $FirePoint
@onready var healthbar = $Sprite2D/EnemyHealthBar

var health
var max_health = 75
var hit = false
var dead = false

func _ready():
	health = max_health
	healthbar.init_health(health)
	shooting = true
	shoot()

func shoot():
	while shooting && !dead:
		animation_player.play("attack")
		await get_tree().create_timer(firerate).timeout

func fire():
	var spawned_arrow = arrow.instantiate()
	spawned_arrow.direction = fire_point.scale.x
	spawned_arrow.global_position = fire_point.position
	add_child(spawned_arrow)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func taking_damage(damage_amount):
	if !dead:
		health -= damage_amount
		animation_player.play("hit")
		healthbar._set_health(health)
	
	if health <= 0:
		die()

func die():
	dead = true
	animation_player.play("dead")
	await get_tree().create_timer(0.4).timeout
	queue_free()
