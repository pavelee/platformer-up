extends EnemyBase

class_name BlueBird

@export var custom_path: CustomPathFllow
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var dead = false

func _process(delta: float) -> void:
	animated_sprite_2d.flip_h = custom_path.direction == 1

func _on_top_area_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	
	dead = true
	
	var player = body as Player
	custom_path.can_move = false
	animated_sprite_2d.play("hit")
	animated_sprite_2d.animation_finished.connect(func(): queue_free())
	player.bounce_up(250)

func _on_bottom_area_body_entered(body: Node2D) -> void:
	if body is not Player or dead:
		return
		
	EventManager.on_player_dead.emit()
