extends CanvasLayer

@onready var pause_panel = $PauseMargin/PausePanel

var is_closing = false

func _ready():
	get_tree().paused = true
	pause_panel.pivot_offset = pause_panel.size / 2
	
	$AnimationPlayer.play("default")
	
	var tween = create_tween()
	tween.tween_property(pause_panel, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(pause_panel, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event):
	if event.is_action_pressed("ESCAPE") || event.is_action_pressed("P"):
		close()
		get_tree().root.set_input_as_handled()


func close():
	if is_closing:
		return
	
	is_closing = true
	$AnimationPlayer.play_backwards("default")
	
	var tween = create_tween()
	tween.tween_property(pause_panel, "scale", Vector2.ONE, 0.0)
	tween.tween_property(pause_panel, "scale", Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()


func _on_resume_button_pressed():
	close()


func _on_quit_to_menu_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_to_desktop_button_pressed():
	get_tree().quit()
