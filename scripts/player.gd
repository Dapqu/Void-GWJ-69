extends CharacterBody2D
class_name Player

signal death
signal character_swap

# Jumping variable for both characters' movement.
const BASE_JUMP_SPEED: float = 300.0
const JUMP_SPEED_INCR: float = 9.375

# The character experience different gravity,
# depending on whether jump button is being held or not.
const GRAVITY_WITH_OUT_JUMP_HELD: float = 1350.0
const GRAVITY_WITH_JUMP_HELD: float = 675.0

# Different character as player has different speed:
# Mage speed;
const MAX_WALK_SPEED: float = 135.0
# Flamethrower speed.
const MAX_RUN_SPEED: float = 180.0

# Acceleration and deceleration for both characters' movement.
const ACCELERATION: float = 337.5
const DECELERATION: float = 300.0

# Reference variables from the project settings or scene tree.
var gravity_vector = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
@onready var mage = $Visuals/mage
@onready var flamethrower = $Visuals/flamethrower
@onready var visuals = $Visuals
@onready var portal = $"../Portal"

# Default variables.
var animated_sprite_2d : AnimatedSprite2D = mage

var direction: float = 0.0

var jumping: bool = false
@export var is_mage: bool = false

var max_speed: float = 0.0
var gravity: float = 0.0

var base_rotation
var base_gravity_vector
var base_up_direction 

func _ready():
	base_rotation = rotation
	base_gravity_vector = gravity_vector
	base_up_direction = up_direction
	
	reset()


func handle_character_swap():
	if Input.is_action_just_pressed("SPACE"):
		ScreenTransition.transition()
		await ScreenTransition.transition_halfway
		
		character_swap.emit()
		
		is_mage = !is_mage
		mage.visible = is_mage
		flamethrower.visible = !is_mage
	
	if is_mage:
		animated_sprite_2d = mage
		max_speed = MAX_WALK_SPEED
	else:
		animated_sprite_2d = flamethrower
		max_speed = MAX_RUN_SPEED


func mage_rotate_player(rotation_direction):
	# Change player roation.
	rotation += rotation_direction * -(PI / 2)
	# Change gravity direction.
	gravity_vector = round(gravity_vector.rotated(rotation_direction * -(PI / 2)))
	# Change the up_direction for jumping.
	up_direction = -gravity_vector


func mage_process():
	# Rotate player and gravity direction.
	if Input.is_action_just_pressed("LMB"):
		mage_rotate_player(-1)
	elif Input.is_action_just_pressed("RMB"):
		mage_rotate_player(1)
	
	# Handle animations.
	if is_on_floor():
		animated_sprite_2d.play("idle" if direction == 0 else "walk")
	# Only play jump animation when jumping, not when falling.
	else:
		if gravity_vector.x != 0:
			animated_sprite_2d.play("jump" if velocity.x * gravity_vector.x < 0 else "")
		elif gravity_vector.y != 0:
			animated_sprite_2d.play("jump" if velocity.y * gravity_vector.y < 0 else "")


func flamethrower_process():
	# Handle animations.
	animated_sprite_2d.play("idle" if direction == 0 else "walk")


func handle_direction():
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("A", "D")
	var facing_direction = direction
	
	# Adjust direction based on gravity orientation.
	if gravity_vector.x > 0 || gravity_vector.y < 0:
		direction *= -1
	
	# Handle sprite's render direction.
	if facing_direction > 0:
		visuals.scale.x = 1
	elif facing_direction < 0:
		visuals.scale.x = -1


func jump_speed():
	var base_speed: float = BASE_JUMP_SPEED
	var speed_incr: float = JUMP_SPEED_INCR
	
	# Jump height is limited by character's movement speed
	return -(base_speed + speed_incr * int(abs(velocity.x) / 30))


func handle_jumping(delta):
	if is_on_floor():
		jumping = false
		
		if Input.is_action_just_pressed("W"):
			velocity = jump_speed() * gravity_vector
			jumping = true
		
	if Input.is_action_just_released("W"):
		jumping = false
	
	# Apply the gravity.
	if not is_on_floor():
		if jumping:
			gravity = GRAVITY_WITH_JUMP_HELD
		else:
			gravity = GRAVITY_WITH_OUT_JUMP_HELD
			
		velocity += gravity_vector * gravity * delta
		print(velocity)


func handle_movement(delta):
	if gravity_vector.x == 0:
		if direction:
			velocity.x = move_toward(velocity.x, direction * max_speed, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	elif gravity_vector.y == 0:
		if direction:
			velocity.y = move_toward(velocity.y, direction * max_speed, ACCELERATION * delta)
		else:
			velocity.y = move_toward(velocity.y, 0, DECELERATION * delta)
		
	move_and_slide()


func _physics_process(delta):
	handle_character_swap()
	
	# Handle characters.
	if is_mage:
		mage_process()
	else:
		flamethrower_process()
	
	handle_direction()
	handle_jumping(delta)
	handle_movement(delta)


func _process(delta):
	$OffscreenIndicator.look_at(portal.global_position)


func _on_area_2d_area_entered(area):
	get_tree().paused = true
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func reset():
	rotation = base_rotation
	gravity_vector = base_gravity_vector
	up_direction = base_up_direction
	
	# On load, playable character is the flamethrower.
	is_mage = false
	# Set default character.
	mage.visible = is_mage
	flamethrower.visible = !is_mage
	# Set movement speed base on default character.
	if is_mage:
		max_speed = MAX_WALK_SPEED
	else:
		max_speed = MAX_RUN_SPEED
	# Set default gravity.
	gravity = GRAVITY_WITH_OUT_JUMP_HELD
	
	position = Vector2(342, 326)
	velocity = Vector2.ZERO


func _on_enemy_collision_area_entered(area):
	death.emit()
	$AudioStreamPlayer.play()
	call_deferred("reset")
