extends CanvasLayer
 
signal transition_halfway
 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var phet = $Phet
@onready var phew = $Phew
@onready var color_rect = $ColorRect

func transition():
	color_rect.visible = true
	phet.play()
	animation_player.play("default")
	await animation_player.animation_finished
	transition_halfway.emit()
	phew.play()
	animation_player.play_backwards("default")
	await animation_player.animation_finished
	color_rect.visible = false
