# res://scripts/level_1_setup.gd
extends Node2D

func _ready():
	var exit = $LevelExit
	exit.level_completed.connect(_on_level_completed)

func _on_level_completed():
	print("Level 1 Complete!")
	Transition.fade_to_scene("res://scenes/levels/level_2.tscn")
