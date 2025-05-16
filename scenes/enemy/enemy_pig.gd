extends EnemyBase

@export var walk_speed: float = 50
@export var angry_speed: float = 200

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var platform_sticker: RayCast2D = %PlatformSticker
@onready var detection: RayCast2D = %Detection

# walk, angry
var _mode = 'walk';
var _is_dead = false
var _current_speed: float
var _direction = 1

func _ready() -> void:
	_mode = 'walk'
	_current_speed = walk_speed
	animated_sprite_2d.play("walk")

# PHTSICS PROCESS INSTEAD OF PROCESS!!!
func _physics_process(delta: float) -> void:
	if not _is_dead:
		velocity.x = _current_speed * _direction
		move_and_slide()
		
		if detection.is_colliding():
			make_angry()
		else:
			calm_down()
		detect_end_of_platform_and_turn()
		
func detect_end_of_platform_and_turn() -> void:
	if platform_sticker.is_colliding():
		return
		
	turn_around(_direction * -1)

func make_angry() -> void:
	if _mode == 'angry':
		return;
	
	_mode = 'angry';
	_current_speed = angry_speed
	animated_sprite_2d.play("run")
	
func calm_down() -> void:
	if _mode == 'walk':
		return;
	
	_mode = 'walk';
	_current_speed = walk_speed
	animated_sprite_2d.play("walk")
	
func turn_around(_d: int) -> void:
	if _direction == _d:
		return
		
	_direction = _d
	platform_sticker.scale.x = _direction
	#platform_sticker.target_position.x = platform_sticker.target_position.x * _direction
	detection.scale.x = _direction
	animated_sprite_2d.scale.x = _direction

func _on_top_area_body_entered(body: Node2D) -> void:
	if body is not Player and _is_dead:
		return
	
	_is_dead = true
	animated_sprite_2d.play("hit1")
	animated_sprite_2d.animation_finished.connect(func(): queue_free())


func _on_bottom_area_body_entered(body: Node2D) -> void:
	if body is not Player and _is_dead:
		return
	
	EventManager.on_player_dead.emit()
