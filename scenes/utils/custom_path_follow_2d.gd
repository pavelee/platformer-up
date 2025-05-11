extends PathFollow2D

class_name CustomPathFllow

@export var move_speed: float = 0.5

var direction = 1;
var can_move: bool = true

func _process(delta: float) -> void:
	if not can_move:
		return
		
	progress_ratio += move_speed * delta * direction
	
	if progress_ratio >= 1 or progress <= 0: 
		direction *= -1
	
