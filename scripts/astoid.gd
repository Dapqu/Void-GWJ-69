extends AnimatedSprite2D

@export var background_texture_options_to_credit: Texture
@export var background_texture_credit_to_options: Texture
@onready var new_background = $"../NewBackground"
@onready var panel_container = $PanelContainer
@onready var label = $PanelContainer/Label

var tween_modulate: Tween
var tween_hover: Tween

var disabled = false
var base_scale = Vector2.ZERO
var current_scene_name = ""
var new_texture: Texture = null

func _ready():
	base_scale = scale
	current_scene_name = get_tree().current_scene.name
	
	if current_scene_name != "Credit" and current_scene_name != "OptionsMenu":
		disabled = true
	
	if current_scene_name == "OptionsMenu":
		new_texture = background_texture_options_to_credit
	elif current_scene_name == "Credit":
		new_texture = background_texture_credit_to_options


func _on_area_2d_mouse_entered():
	if disabled:
		return
	
	$Hover.play()
	
	if current_scene_name == "Credit":
		label.text = "Back"
	else:
		label.text = "GWJ" 
	
	panel_container.visible = true
	
	# Handle scale.
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", base_scale * 1.3, 2)
	
	# Handle new background.
	if new_background:
		new_background.texture = new_texture
		if tween_modulate and tween_modulate.is_running():
			tween_modulate.kill()
		tween_modulate = create_tween().set_ease(Tween.EASE_OUT)
		tween_modulate.tween_property(new_background, "modulate:a", 1, 0.5)


func _on_area_2d_mouse_exited():
	if disabled:
		return
	
	#$Hover.stop()
	
	panel_container.visible = false
	
	# Reset scale.
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", base_scale, 0.55)
	
	# Reset background.
	if tween_modulate and tween_modulate.is_running():
		tween_modulate.kill()
	tween_modulate = create_tween().set_ease(Tween.EASE_OUT)
	tween_modulate.tween_property(new_background, "modulate:a", 0, 0.55)


func _on_area_2d_input_event(viewport, event, shape_idx):		
	if disabled:
		return
	
	if event.is_action_pressed("LMB"):
		disabled = true
		
		ScreenTransition.transition()
		await ScreenTransition.transition_halfway
		
		if current_scene_name == "Credit":
			get_tree().change_scene_to_file("res://scenes/options_menu.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/credit.tscn")
