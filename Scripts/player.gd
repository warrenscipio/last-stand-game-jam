extends CharacterBody3D

signal try_pickup(player)
signal throw_held_item(throwFromTransform)

var bullet = preload("res://Scenes/bullet.tscn")
var physics_box = preload("res://Scenes/physics_box.tscn")
var turrent_placement = preload("res://Scenes/turret.tscn")

var instance
var newTurrentinstance
@onready var camera_mount = $camera_mount
@onready var visuals = $visuals
@onready var animation_player = $visuals/AnimationPlayer
@onready var gun_animation = $visuals/gun/AnimationPlayer
@onready var gun_barrel = $visuals/gun/RayCast3D
@onready var world_cam = $"../../Camera3D"
@onready var collisionShape = $CollisionShape3D
@export var z_depth = 30
@onready var ray_cast_3d = $"../../Camera3D/RayCast3D"
@onready var player_hud = $playerHud
@onready var burger_stand = $"../burgerStand"
var burger_making_speed = 20

var SPEED = 5
const JUMP_VELOCITY = 8

var walking_speed = 4.0
var running_speed = 7.0
var aiming_speed = 2.0
#if I need to lock the character in an animation 
var is_locked = false
var is_aiming = false
var itemHeld = null
var current_mouse_pos = null
var isInBurgerStandZone = false
var buy_mode = false
var player_money = 0
var turrent_supply = 0


@export var sens_horiz = 0.2
@export var sens_vert = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#good to turn off for debugging
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _input(event):
	if event is InputEventMouseMotion:
		#this almost works
		ray_cast_3d.global_position = world_cam.project_position(get_viewport().get_mouse_position(),0)
		RayCast3D
		look_at(ray_cast_3d.get_collision_point())
		current_mouse_pos = event

func _physics_process(delta):
	
	var over_player = global_position 
	over_player
	player_hud.position = world_cam.unproject_position(global_position) + Vector2(-5,-25)
	
	if !animation_player.is_playing():
		is_locked = false
		
	if Input.is_action_just_pressed("shoot"):
		if player_hud.burger_count > 0:
			if !gun_animation.is_playing():
				gun_animation.play("shoot")
				instance = bullet.instantiate()
				instance.position = gun_barrel.global_position
				instance.transform.basis = gun_barrel.global_transform.basis
				get_parent().get_parent().add_child(instance)
				player_hud.burger_count = player_hud.burger_count - 1
	
	# broadly speaking, the player shouldn't manage the physics of throwing
	# or activating, deactivating it.
	if Input.is_action_just_pressed("throw"):
		emit_signal("throw_held_item", gun_barrel.global_transform)
		
	if Input.is_action_just_pressed("pickup"):
		emit_signal("try_pickup", self)
		
	#currently this locks any ongoing animation (toggle)
	if Input.is_action_just_pressed("interact"):
		#check if you have a turret
		if turrent_supply > 0:
			turrent_supply = turrent_supply - 1
			newTurrentinstance = turrent_placement.instantiate()
			newTurrentinstance.position = global_position
			get_parent().get_parent().add_child(newTurrentinstance)
	
	if Input.is_action_just_pressed("buy_menu"):
		buy_mode = true
		is_locked = true
		player_hud.buy_menu.visible = true
		
	if Input.is_action_just_released("buy_menu"):
		buy_mode = false
		is_locked = false
		
		player_hud.buy_menu.visible = false
		
		if player_hud.burger_select.visible:
			if burger_stand.player_money >= 10:
				burger_stand.player_money = burger_stand.player_money - 10
				player_hud.burger_capacity = player_hud.burger_capacity + 5
				burger_making_speed = burger_making_speed + 20
				
		if player_hud.turret_select.visible:
			if burger_stand.player_money >= 20:
				burger_stand.player_money = burger_stand.player_money - 20
				turrent_supply = turrent_supply + 1 
				
			
		
	if buy_mode :
		if Input.is_action_pressed("left"):
			player_hud.burger_select.visible = true
			player_hud.turret_select.visible = false
		if Input.is_action_pressed("right"):
			player_hud.turret_select.visible = true
			player_hud.burger_select.visible = false

			
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
		
		if Input.is_action_just_pressed("make_burger") && isInBurgerStandZone:
			if player_hud.burger_count != player_hud.burger_capacity:
					player_hud.burger_bar.value = player_hud.burger_bar.value + burger_making_speed
				
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
					
			
			visuals.look_at(position + direction)
			
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			


	move_and_slide()
