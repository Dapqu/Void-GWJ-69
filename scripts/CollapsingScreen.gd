#@tool
extends Control

@export var timer: float

var player
var tween_shrink: Tween


func _ready():
	player = GroupsUtils.player
	player.death.connect(on_death)

	if player:
		shrink()


func shrink():
	if tween_shrink and tween_shrink.is_running():
		create_tween().tween_property(self, "material:shader_parameter/percent", 0, 0)
		tween_shrink.kill()
	tween_shrink = create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_CUBIC)
	tween_shrink.tween_property(self, "material:shader_parameter/percent", 1, timer)
	
	await tween_shrink.finished
		
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().reload_current_scene()


func on_death():
	shrink()


func _process(delta):
	if player:
		material.set_shader_parameter("player_pos",player.get_global_transform_with_canvas().origin - Vector2(0, 12))
