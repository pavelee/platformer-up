extends Area2D

class_name Checkpoint

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# not_reached / reached
var _state: String = 'not_reached'

func _ready() -> void:
	if is_reached(): 
		animated_sprite_2d.play("idle_reached")
	else:
		animated_sprite_2d.play("idle")

func is_reached() -> bool:
	return _state == 'reached'

func reach() -> void:
	_state = 'reached'
	animated_sprite_2d.play("reached")
	animated_sprite_2d.animation_finished.connect(func(): animated_sprite_2d.play("idle_reached"))

func get_checkpoint_position() -> Vector2:
	return global_position

func _on_body_entered(body: Node2D) -> void:
	if body is not Player or is_reached():
		return
	
	if (body as Player).is_dead():
		return
	
	reach()
	EventManager.on_player_reached_checkpoint.emit(self)
	
	
