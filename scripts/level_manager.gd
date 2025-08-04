# res://scripts/level_manager.gd
extends Node2D

@export var ghost_scene: PackedScene = preload("res://scenes/ghost/ghost.tscn")

@onready var ghosts_container: Node2D = $GhostsContainer

var current_player: CharacterBody2D
var active_ghosts: Array = []
var level_start_position: Vector2

func _ready():
	RecordingManager.loop_activated.connect(_on_loop_activated)
	RecordingManager.recording_stopped.connect(_on_recording_stopped)
	
	# Find player in level
	current_player = get_tree().get_first_node_in_group("player")
	if current_player:
		level_start_position = current_player.global_position

func _input(event):
	if Input.is_action_just_pressed("reset"):
		reset_level()

func _on_loop_activated():
	# Spawn ghosts for all recordings
	clear_ghosts()
	
	for i in range(RecordingManager.ghost_recordings.size()):
		var ghost = ghost_scene.instantiate()
		ghosts_container.add_child(ghost)
		ghost.setup(RecordingManager.ghost_recordings[i], i)
		ghost.global_position = level_start_position
		active_ghosts.append(ghost)

func _on_recording_stopped():
	# Reset player to start when recording stops
	if current_player:
		current_player.global_position = level_start_position
		current_player.velocity = Vector2.ZERO

func clear_ghosts():
	for ghost in active_ghosts:
		ghost.queue_free()
	active_ghosts.clear()

func reset_level():
	RecordingManager.reset_all()
	clear_ghosts()
	if current_player:
		current_player.global_position = level_start_position
		current_player.velocity = Vector2.ZERO
		current_player.sprite.modulate = Color.WHITE
