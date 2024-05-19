extends Camera2D

const POSITION_SMOOTHING = 1000

var player = null
var target_position = Vector2.ZERO
var target_rotation = 0.0


func _ready():
	make_current()


func _process(delta):
	player = GroupsUtils.player
	
	if player:
		# Calculate the target position based on the player's position and rotation
		target_position = player.global_position
		target_rotation = player.global_rotation
		
		# Calculate the offset based on player rotation
		var camera_offset = Vector2(0, -80).rotated(target_rotation)  # Adjust the offset values as needed
		# Apply the offset to the target position
		target_position += camera_offset
	
	# Smoothly move the camera towards the target position
	global_position = global_position.lerp(target_position, 1 - exp(-delta * POSITION_SMOOTHING))
	# Set the camera's rotation to match the player's rotation
	global_rotation = target_rotation
