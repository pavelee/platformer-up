extends Node2D

class_name Game

@onready var player: Player = $Player
@onready var spawn_1: Marker2D = %Spawn1

var points: int = 0
var current_spawn_point: Marker2D

func _ready() -> void:
	EventManager.on_player_dead.connect(_on_player_dead)
	EventManager.on_collectable_collected.connect(_on_collectable_collected)
	current_spawn_point = spawn_1

func _on_player_dead() -> void:
	if player.is_dead():
		return
		
	player.dead()
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(player, "global_position", current_spawn_point.position, 1)
	tween.tween_callback(player.respawn)
	
func _on_collectable_collected(collectable: BaseCollective) -> void:
	points += 1
