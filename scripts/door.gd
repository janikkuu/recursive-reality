# res://scripts/door.gd
extends StaticBody2D

@onready var sprite: ColorRect = $ColorRect
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var linked_switch_path: NodePath

var linked_switch: Area2D
var is_open: bool = false
var tween: Tween

func _ready():
	add_to_group("doors")
	if linked_switch_path:
		linked_switch = get_node(linked_switch_path)
		if linked_switch:
			linked_switch.activated.connect(open_door)
			linked_switch.deactivated.connect(close_door)

func open_door():
	if is_open:
		return
	
	is_open = true
	collision.set_deferred("disabled", true)
	
	# Animate door opening
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.3, 0.3)
	tween.parallel().tween_property(sprite, "scale:y", 0.1, 0.3)
	# AudioManager.play_sound("door", -8.0)

func close_door():
	if not is_open:
		return
	
	is_open = false
	collision.set_deferred("disabled", false)
	
	# Animate door closing
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(sprite, "scale:y", 1.0, 0.2)
