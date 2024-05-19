extends Node2D

var pause_menu_scene = preload("res://scenes/pause_menu.tscn")

var tween_hover: Tween


func _unhandled_input(event):
	if event.is_action_pressed("ESCAPE") || event.is_action_pressed("P"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()
