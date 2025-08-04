# res://scripts/ghost.gd
extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var detection_area: Area2D = $Area2D

var recording_data: Array = []
var current_frame: int = 0
var ghost_number: int = 0
var trail: CPUParticles2D

func _ready():
	add_to_group("ghosts")
	
	# Scale down the 80x80 sprite to 32x32
	sprite.scale = Vector2(0.4, 0.4)
	
	# Make ghost solid for player to stand on
	collision_layer = 3
	collision_mask = 1
	
	# Area2D for switch detection
	detection_area.collision_layer = 4  # New layer for ghost detection
	detection_area.collision_mask = 0   # Doesn't need to detect anything
	
	detection_area.add_to_group("ghosts")

func setup(recording: Array, number: int):
	recording_data = recording
	ghost_number = number
	current_frame = 0
	
	# Set ghost color based on number
	if ghost_number == 0:
		sprite.modulate = Color(1, 0.5, 0.5, 1)  # Red tint + transparency
	else:
		sprite.modulate = Color(0.5, 0.5, 1, 1)  # Blue tint + transparency
	
	setup_trail()

func setup_trail():
	trail = CPUParticles2D.new()
	add_child(trail)
	trail.emitting = true
	trail.amount = 50
	trail.lifetime = 1
	trail.speed_scale = 1.0
	trail.direction = Vector2(0, 1)
	trail.initial_velocity_min = 50.0
	trail.initial_velocity_max = 100.0
	trail.gravity = Vector2(0, 98)  # Add some gravity
	
	# Set trail color based on ghost number
	if ghost_number == 0:
		trail.color = Color(1, 0, 0, 0.5)  # Red trail
	else:
		trail.color = Color(0, 0, 1, 0.5)  # Blue trail
	trail.scale_amount_min = 0.5
	trail.scale_amount_max = 1.0

func _physics_process(delta):
	if current_frame < recording_data.size():
		var frame_data = recording_data[current_frame]
		global_position = frame_data["position"]
		#velocity = frame_data["velocity"]
		
		# Make sure trail follows the ghost
		if trail:
			trail.position = Vector2.ZERO  # Trail relative to ghost position
		
		# Update visual based on state
		if frame_data["facing_direction"] < 0:
			sprite.scale.x = -0.4
		else:
			sprite.scale.x = 0.4
		
		current_frame += 1
		#move_and_slide()
	else:
		# Loop the ghost
		current_frame = 0
