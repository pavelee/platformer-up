extends Node2D

class_name Game

@onready var player: Player = $Player

var points: int = 0

func _ready() -> void:
	EventManager.on_player_dead.connect(_on_player_dead)
	EventManager.on_collectable_collected.connect(_on_collectable_collected)

func _on_player_dead() -> void:
	player.dead()
	
func _on_collectable_collected(collectable: BaseCollective) -> void:
	points += 1
