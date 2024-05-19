extends Node2D

var pause_menu_scene = preload("res://scenes/pause_menu.tscn")
@onready var gravity_tooltip = $GravityTooltip

var tween_hover: Tween

func _ready():
	gravity_tooltip.scale = Vector2.ZERO

func _unhandled_input(event):
	if event.is_action_pressed("ESCAPE") || event.is_action_pressed("P"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()


func _on_area_2d_area_entered(area):
	gravity_tooltip.visible = true
	
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(gravity_tooltip, "scale", Vector2.ONE, 1)
