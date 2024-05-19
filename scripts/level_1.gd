extends Node2D

var pause_menu_scene = preload("res://scenes/pause_menu.tscn")

var death_count: int = 0

func _ready():
	GroupsUtils.player.death.connect(on_death)
	GroupsUtils.player.character_swap.connect(on_character_swap)

func _unhandled_input(event):
	if event.is_action_pressed("ESCAPE") || event.is_action_pressed("P"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()


func on_character_swap():
	if death_count == 1:
		$JumpTooltip.visible = true


func on_death():
	death_count += 1
	
	if death_count == 1:
		$MovementTooltip.visible = false
		$CharacterSwapTooltip.visible = true
	elif death_count == 2:
		$CharacterSwapTooltip.visible = false
		$SpeedTooltip.visible = true
	
