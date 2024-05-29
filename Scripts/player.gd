extends CharacterBody3D


var bullet = load("res://Scenes/bullet.tscn")
var instance
@onready var camera_mount = $camera_mount
@onready var visuals = $visuals
@onready var animation_player = $visuals/AnimationPlayer
@onready var gun_animation = $visuals/gun/AnimationPlayer
@onready var gun_barrel = $visuals/gun/RayCast3D
@onready var player_cam = $camera_mount/Camera3D

var SPEED = 5
const JUMP_VELOCITY = 8

var walking_speed = 4.0
var running_speed = 45.0
var aiming_speed = 2.0
#if I need to lock the character in an animation 
var is_locked = false
var is_aiming = false
var current_mouse_pos = null

@export var sens_horiz = 0.2
@export var sens_vert = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#good to turn off for debugging
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horiz))

		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vert))
		if !is_aiming:
			
			visuals.rotate_y(deg_to_rad(event.relative.x * sens_horiz))
		#grab mouse data for this frame for other functions
		current_mouse_pos = event


func _physics_process(delta):
	
	if !animation_player.is_playing():
		is_locked = false
		
	#if Input.is_action_just_pressed("shoot"):
		#if !gun_animation.is_playing():
			#gun_animation.play("shoot")
			#instance = bullet.instantiate()
			#instance.position = gun_barrel.global_position
			#instance.transform.basis = gun_barrel.global_transform.basis
			#get_parent().get_parent().add_child(instance)
		
	#currently this locks any ongoing animation (toggle)
	if Input.is_action_just_pressed("interact"):
		is_locked = !is_locked
	
	if Input.is_action_just_pressed("atk"):
		if animation_player.current_animation != "atk":
			animation_player.play("atk")
			is_locked = true	
			
	if Input.is_action_pressed("run"):
		SPEED = running_speed
	else:
		SPEED = walking_speed
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if !is_locked:
		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		#aiming whiling moving
		if Input.is_action_pressed("aim"):
			is_aiming = true
			SPEED = aiming_speed
			visuals.rotation = Vector3.ZERO
			
		if Input.is_action_just_released("aim"):
			is_aiming = false

				
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			if SPEED == running_speed:
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
					
			if !is_aiming:
				visuals.look_at(position + direction)
			
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			


	move_and_slide()