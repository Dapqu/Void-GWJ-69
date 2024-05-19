extends AnimatedSprite2D

var player = null

func _ready():
	self_modulate.a = 0
	
	player = GroupsUtils.player
	player.character_swap.connect(on_character_swap)
	player.death.connect(on_death)

func on_character_swap():
	if self_modulate.a == 0:
		self_modulate.a = 255
	else:
		self_modulate.a = 0

func on_death():
	self_modulate.a = 0
