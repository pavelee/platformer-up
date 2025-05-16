extends Node

const FRUIT = preload("res://Assets/Sound/fruit.ogg")
const HIT = preload("res://Assets/Sound/hit.ogg")
const JUMPING_SFX = preload("res://Assets/Sound/jumping sfx.mp3")

@onready var sfx_streams: Node = $SfxStreams

func on_fruit_collected() -> void:
	play_audio(FRUIT)
	
func on_player_hit() -> void:
	play_audio(HIT)
	
func on_player_jump() -> void:
	play_audio(JUMPING_SFX)

func play_audio(stream: AudioStream) -> void:
	var s = get_free_audio_player()
	s.stream = stream
	s.play()
	
func get_free_audio_player() -> AudioStreamPlayer2D:
	return sfx_streams.get_children().filter(
		func(stream: AudioStreamPlayer2D): return not stream.playing
	).pick_random()
