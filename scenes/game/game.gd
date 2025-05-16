extends Node2D

class_name Game

@onready var player: Player = $Player
@onready var spawn_1: Marker2D = %Spawn1

var points: int = 0
var current_spawn_point: Vector2

@onready var score_label: Label = %ScoreLabel
@onready var game_won: Panel = %GameWon

func _ready() -> void:
	EventManager.on_player_dead.connect(_on_player_dead)
	EventManager.on_collectable_collected.connect(_on_collectable_collected)
	EventManager.on_player_reached_checkpoint.connect(_on_player_reached_checkpoint)
	EventManager.on_game_won.connect(_on_game_won)
	current_spawn_point = spawn_1.position

func _on_player_dead() -> void:
	if player.is_dead():
		return
	
	SoundManager.on_player_hit()
	player.dead()
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(player, "global_position", current_spawn_point, 1)
	tween.tween_callback(player.respawn)
	
func _on_collectable_collected(collectable: BaseCollective) -> void:
	SoundManager.on_fruit_collected()
	points += 1
	score_label.text = str(points)

func _on_player_reached_checkpoint(checkpoint: Checkpoint) -> void:
	current_spawn_point = checkpoint.get_checkpoint_position()

func _on_game_won() -> void:
	game_won.show()


func _on_play_pressed() -> void:
	get_tree().reload_current_scene()
