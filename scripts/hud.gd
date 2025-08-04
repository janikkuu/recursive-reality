# res://scripts/hud.gd
extends CanvasLayer

@onready var loop_counter: Label = $Control/VBoxContainer/LoopCounter
@onready var prompt_label: Label = $Control/VBoxContainer/PromptLabel
@onready var timer_label: Label = $Control/VBoxContainer/TimerLabel

func _ready():
	RecordingManager.recording_started.connect(_on_recording_started)
	RecordingManager.recording_stopped.connect(_on_recording_stopped)

func _process(delta):
	# Update loop counter
	var ghost_count = RecordingManager.get_ghost_count()
	loop_counter.text = "Loops: %d/%d" % [ghost_count, RecordingManager.MAX_GHOSTS]
	
	# Update prompts
	if RecordingManager.is_recording:
		prompt_label.text = "RECORDING... Press Q to create loop"
		timer_label.visible = true
		timer_label.text = "Time: %.1f/10.0s" % RecordingManager.recording_timer
	else:
		timer_label.visible = false
		if ghost_count < RecordingManager.MAX_GHOSTS:
			prompt_label.text = "Press Q to start loop | Press R to reset"
		else:
			prompt_label.text = "Max loops reached! Press R to reset"

func _on_recording_started():
	loop_counter.modulate = Color(1, 1, 0)  # Yellow during recording

func _on_recording_stopped():
	loop_counter.modulate = Color.BLACK
