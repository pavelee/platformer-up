extends CharacterBody2D

class_name EnemyRino

@export var move_speed: float = 300
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = %RayCast2D
@onready var detect_area_collision: CollisionShape2D = $DetectArea/DetectAreaCollision

var _is_charging = false
var _direction = -1

func _ready() -> void:
	animated_sprite_2d.play("idle")

func _physics_process(delta: float) -> void:
	if _is_charging:
		velocity.x += move_speed * delta * _direction
		handle_wall_collistion()
		move_and_slide()

func turn_around() -> void:
	_direction = _direction * -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	ray_cast_2d.target_position.x = ray_cast_2d.target_position.x * -1
	detect_area_collision.position.x = position.x * -1

func handle_wall_collistion():
	if 	not ray_cast_2d.is_colliding():
		return
	
	turn_around()
	_is_charging = false
	velocity.x = 0
	animated_sprite_2d.play("hit_wall")
	animated_sprite_2d.animation_finished.connect(func(): animated_sprite_2d.play("idle"))
	
func _on_bottom_area_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	
	EventManager.on_player_dead.emit()


func _on_top_area_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	
	var player = body as Player
	player.bounce_up(400)
	animated_sprite_2d.play("hit")
	_is_charging = false
	animated_sprite_2d.animation_finished.connect(func(): queue_free())


func _on_detect_area_body_entered(body: Node2D) -> void:
	if _is_charging: return
	
	_is_charging = true
	animated_sprite_2d.play("run")
	
