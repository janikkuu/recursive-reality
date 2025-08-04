# res://scripts/player.gd
extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 980.0

@onready var ground_ray: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D

var facing_direction: int = 1
var start_position: Vector2
var original_scale: Vector2

func _ready():
	add_to_group("player")
	start_position = global_position
	original_scale = Vector2(0.4, 0.4)  # Scale 80x80 down to 32x32
	RecordingManager.recording_started.connect(_on_recording_started)
	
	collision_layer = 1
	collision_mask = 3

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		# AudioManager.play_sound("jump", -10.0)
	
	# Handle movement
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * move_speed
		facing_direction = int(sign(direction))
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed * 3.0 * delta)
	
	# Record current frame
	if RecordingManager.is_recording:
		RecordingManager.record_frame(get_current_state())
	
	# Handle loop input
	if Input.is_action_just_pressed("loop"):
		if RecordingManager.start_recording():
			global_position = start_position
			velocity = Vector2.ZERO
	
	# Squash and stretch
	if velocity.y < -10 and not is_on_floor():
		sprite.scale = original_scale * Vector2(0.8, 1.2)
	elif velocity.y > 10:
		sprite.scale = original_scale * Vector2(1.2, 0.8)
	else:
		sprite.scale = sprite.scale.lerp(original_scale, 0.2)
	
	move_and_slide()

func get_current_state() -> Dictionary:	
	return {
		"position": global_position,
		"velocity": velocity,
		"is_jumping": not is_on_floor(),
		"facing_direction": facing_direction
	}

func _on_recording_started():
	sprite.modulate = Color(1, 1, 0.8)  # Slight yellow tint
