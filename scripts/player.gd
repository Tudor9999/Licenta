extends CharacterBody2D
class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



@onready var timer = $Timer
@onready var audio_player = $AudioStreamPlayer

@onready var animation_player = $AnimationPlayer
@onready var attack_area = $AttackArea/CollisionShape2D
@onready var attacking_area = $AttackArea
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var health_bar = $HealthBar
@onready var attack_sound = $AttackSound
@onready var hit_sound = $HitSound
@onready var die_sound = $DieSound
@onready var roll_sound = $RollSound

@export var attacking = false
@export var dead = false

var max_health = 100
var health = 0
var take_damage = true
var rolling = false

func _ready():
	health = max_health
	health_bar.init_health(health)

func _process(delta):
	if Input.is_action_just_pressed("Attack1"):
		attack_sound.play()
		attack()
	if Input.is_action_just_pressed("roll"):
		roll_sound.play()
		roll()

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		sprite_2d.flip_h = false
		sprite_2d.offset = Vector2(0, 0)
		attack_area.position = Vector2(39, 4.5)
	elif direction < 0:
		sprite_2d.offset = Vector2(-41, 0)
		attack_area.position = Vector2(-45, 4.5)
		sprite_2d.flip_h = true
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	update_animation()
	move_and_slide()

func attack():
	var overlaping_objects = attacking_area.get_overlapping_areas()
	for area in overlaping_objects:
		if area.get_parent().is_in_group("Enemies"):
			area.get_parent().taking_damage(25)
	
	attacking = true
	animation_player.play("attack1")

func update_animation():
	if !dead:
		if rolling:
			animation_player.play("roll")
		else:
			if !take_damage:
				animation_player.play("take_damage")
			else:
				if !attacking:
					if is_on_floor():
						if velocity.x == 0:
							animation_player.play("idle")
						else:
							
							animation_player.play("run")
					else:
						animation_player.play("jump")

func taking_damage(damage : int):
	if take_damage:
		iframes()
		hit_sound.play()
		health -= damage
		health_bar._set_health(health)
		
		if health <= 0:
			die()

func iframes():
	take_damage = false
	await get_tree().create_timer(0.3).timeout
	take_damage = true

func roll_iframes():
	collision_shape_2d.disabled = true
	rolling = true
	await  get_tree().create_timer(0.65).timeout
	collision_shape_2d.disabled = false
	rolling = false

func roll():
	roll_iframes()

func _on_timer_timeout():
	GameManager.diamonds = 0
	health = max_health
	get_tree().reload_current_scene()
	dead = false

func die():
	dead = true
	die_sound.play()
	animation_player.play("dead")
	timer.start()
