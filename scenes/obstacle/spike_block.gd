extends StaticBody2D

class_name SpikeBlock

@export var rotation_interval: float = 2.0

var timer: float

func _process(delta: float) -> void:
	timer += delta
	if timer >= rotation_interval:
		do_rotation()
		timer = 0.0

func do_rotation() -> void:
	var current_rotation = rotation_degrees
	var desire_rotation = current_rotation - 90
	var tween := create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees", desire_rotation, 0.5)
