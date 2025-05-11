extends Area2D

class_name BaseCollective

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var collected: bool = false 

func _on_body_entered(body: Node2D) -> void:
	if body is not Player or collected:
		return
	
	collected = true 
	EventManager.on_collectable_collected.emit(self)
	animated_sprite_2d.play("collected")
	animated_sprite_2d.animation_finished.connect(func(): queue_free())
	
