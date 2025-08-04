# res://scripts/level_exit.gd
extends Area2D

signal level_completed

@onready var particles: CPUParticles2D = $CPUParticles2D

var player_inside: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Setup particles
	particles.emitting = true
	particles.amount = 20
	particles.lifetime = 1.0
	particles.speed_scale = 0.5
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particles.emission_rect_extents = Vector2(24, 24)
	particles.color = Color(1, 1, 0, 0.8)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		level_completed.emit()
		# AudioManager.play_sound("success")
		# Victory effect
		particles.amount = 50
		particles.speed_scale = 2.0

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
