# res://scripts/pressure_switch.gd
extends Area2D

signal activated
signal deactivated

@onready var sprite: ColorRect = $ColorRect

var is_active: bool = false
var bodies_on_switch: int = 0

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	add_to_group("switches")
	
	collision_mask = 3

func _on_body_entered(body):
	print("Body entered: ", body.name, " - Groups: ", body.get_groups())
	if body.is_in_group("player") or body.is_in_group("ghosts"):
		bodies_on_switch += 1
		print("Valid body! Bodies on switch: ", bodies_on_switch)
		if not is_active:
			activate()

func _on_body_exited(body):
	print("Body exited: ", body.name, " - Groups: ", body.get_groups())
	if body.is_in_group("player") or body.is_in_group("ghosts"):
		bodies_on_switch -= 1
		print("Valid body left! Bodies on switch: ", bodies_on_switch)
		if bodies_on_switch <= 0 and is_active:
			deactivate()

func activate():
	print("Switch activated!")
	is_active = true
	sprite.color = Color(0, 1, 0)  # Green when active
	sprite.scale.y = 0.5  # Visual compression
	activated.emit()
	# AudioManager.play_sound("switch", -5.0)

func deactivate():
	print("Switch deactivated!")
	is_active = false
	sprite.color = Color(1, 1, 0)  # Yellow when inactive
	sprite.scale.y = 1.0
	deactivated.emit()
