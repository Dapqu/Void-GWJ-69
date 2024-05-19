extends CanvasLayer

@export var timer: float
@onready var color_rect = $ColorRect

var tween_shrink: Tween
var tween_aplha: Tween

func _ready():
	if tween_shrink and tween_shrink.is_running():
		tween_shrink.kill()
	tween_shrink = create_tween().set_ease(Tween.EASE_IN)
	tween_shrink.tween_property(color_rect, "material:shader_parameter/percent", 1, timer)
	
	if tween_aplha and tween_aplha.is_running():
		tween_aplha.kill()
	tween_aplha = create_tween().set_ease(Tween.EASE_IN)
	tween_aplha.tween_property(color_rect, "modulate:a", 1, timer)
	
	await tween_shrink.finished
	await tween_aplha.finished
	
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().reload_current_scene()
