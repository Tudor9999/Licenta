extends CharacterBody2D
class_name Player

const SPEED = 175.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



@onready var timer = $Timer

@onready var animation_player = $AnimationPlayer
@onready var attack_area = $AttackArea/CollisionShape2D

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

@export var attacking = false
@export var dead = false

func _process(delta):
	if Input.is_action_just_pressed("Attack1"):
		attack()

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
		attack_area.position = Vector2(37, 4.5)
		collision_shape_2d.position = Vector2(22, -13)
	elif direction < 0:
		sprite_2d.offset = Vector2(-41, 0)
		attack_area.position = Vector2(-37, 4.5)
		collision_shape_2d.position = Vector2(-22, -13)
		sprite_2d.flip_h = true
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	update_animation()
	move_and_slide()

func attack():
	var overlaping_objects = $AttackArea.get_overlapping_areas()
	for area in overlaping_objects:
		if area.get_parent().is_in_group("Enemies"):
			area.get_parent().die()
	
	attacking = true
	attack_area.disabled = false
	animation_player.play("attack1")

func update_animation():
	if !dead:
		if !attacking:
			attack_area.disabled = true
			if is_on_floor():
				
				if velocity.x == 0:
					animation_player.play("idle")
				else:
					animation_player.play("run")
			else:
				animation_player.play("jump")

func _on_timer_timeout():
	get_tree().reload_current_scene()
	dead = false

func die():
	dead = true
	animation_player.play("dead")
	timer.start()
