extends CharacterBody2D

class_name Player

@export var max_speed: float = 180
@export var jump_force: float = 450
@export var max_jump: int = 2
@export var gravity: float = 1600

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var jumps_left: int
var move_direction: int = 1
var can_move: bool = true

func _ready() -> void:
	jumps_left = max_jump
	
func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	handle_movement()
	handle_gravitiy(delta)
	handle_wall_collision()
	handle_jump_input()
	
	move_and_slide()

func handle_movement() -> void:
	velocity.x = move_direction * max_speed
	if is_on_floor():
		animated_sprite_2d.play("run")
		jumps_left = max_jump

func handle_gravitiy(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_wall_collision() -> void:
	if not ray_cast_2d.is_colliding():
		return
		
	velocity.y = 50
	jumps_left = max_jump
	animated_sprite_2d.play("fall")
	
	if is_on_floor():
		change_direction()

func change_direction() -> void:
	# change velocity direction on next frame
	move_direction *= -1
	# change sprite direction (turn the player)
	scale.x *= -1

func handle_jump_input() -> void:
	if not Input.is_action_just_pressed("tap"):
		return
	
	if ray_cast_2d.is_colliding(): 
		change_direction()
		jump()
	else:
		jump()

func jump() -> void:
	if jumps_left <= 0:
		return
	
	velocity.y = -jump_force
	jumps_left -= 1
	
	if jumps_left <= 0:
		animated_sprite_2d.play("duble_jump")
	else:
		animated_sprite_2d.play("jump")

func bounce_up(amount: float) -> void:
	velocity.y = amount * -1

func is_dead() -> bool:
	return can_move == false

func dead() -> void:
	if not can_move:
		return
	can_move = false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("dead")
	
func respawn() -> void:
	animated_sprite_2d.play("respawn")
	await animated_sprite_2d.animation_finished
	can_move = true
