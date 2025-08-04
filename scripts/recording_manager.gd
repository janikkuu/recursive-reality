# res://scripts/recording_manager.gd
extends Node

signal recording_started
signal recording_stopped
signal loop_activated

const MAX_RECORDING_FRAMES = 600  # 10 seconds at 60fps
const MAX_GHOSTS = 2

var is_recording: bool = false
var current_recording: Array = []
var ghost_recordings: Array = []
var recording_timer: float = 0.0

func _ready():
	set_process(false)

func start_recording():
	if ghost_recordings.size() >= MAX_GHOSTS:
		return false
	
	is_recording = true
	current_recording.clear()
	recording_timer = 0.0
	set_process(true)
	recording_started.emit()
	return true

func stop_recording():
	if not is_recording:
		return
	
	is_recording = false
	set_process(false)
	
	if current_recording.size() > 0:
		ghost_recordings.append(current_recording.duplicate())
		recording_stopped.emit()
		loop_activated.emit()

func record_frame(state: Dictionary):
	if is_recording and current_recording.size() < MAX_RECORDING_FRAMES:
		current_recording.append(state)

func _process(delta):
	if is_recording:
		recording_timer += delta
		if recording_timer >= 10.0:  # 10 second limit
			stop_recording()

func get_ghost_count() -> int:
	return ghost_recordings.size()

func reset_all():
	is_recording = false
	current_recording.clear()
	ghost_recordings.clear()
	recording_timer = 0.0
	set_process(false)
