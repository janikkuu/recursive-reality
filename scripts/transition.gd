# res://scripts/transition.gd
extends CanvasLayer

var fade_rect: ColorRect

func _ready():
	fade_rect = ColorRect.new()
	add_child(fade_rect)
	fade_rect.color = Color.BLACK
	fade_rect.anchor_right = 1.0
	fade_rect.anchor_bottom = 1.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_rect.modulate.a = 0.0

func fade_to_scene(scene_path: String):
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 0.3)
	tween.tween_callback(get_tree().change_scene_to_file.bind(scene_path))
	tween.tween_property(fade_rect, "modulate:a", 0.0, 0.3)
