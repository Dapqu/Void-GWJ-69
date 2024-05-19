extends AnimatedSprite2D

@export var background_texture: Texture
@onready var new_background = $"../NewBackground"
@onready var panel_container = $PanelContainer

var tween_modulate: Tween
var tween_hover: Tween

var disabled = false
var base_scale = Vector2.ZERO

func _ready():
	base_scale = scale


func _on_area_2d_mouse_entered():
	if disabled:
		return
	
	$Hover.play()
	
	panel_container.visible = true
	
	# Handle scale.
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", base_scale * 1.3, 2)
	
	# Handle new background.
	new_background.texture = background_texture
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
		get_tree().quit()
