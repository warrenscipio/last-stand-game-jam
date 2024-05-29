extends Node3D
@onready var animation_player = $AnimationPlayer
@onready var pivot_point = $StaticBody3D/pivot_point
@onready var ray_cast_3d = $StaticBody3D/pivot_point/barrel/RayCast3D
@onready var timer = $Timer

var bullet = load("res://Scenes/bullet.tscn")
var bullet_instance
var locked_on = false
var locked_on_body
var fire_rate = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if locked_on:
		pivot_point.look_at(locked_on_body.global_position)
		pivot_point.rotation.x = 0
		pivot_point.rotation.z = 0
	

func turret_shot():
	if !animation_player.is_playing():
		animation_player.play("shoot")
		bullet_instance = bullet.instantiate()
		bullet_instance.position = ray_cast_3d.global_position
		bullet_instance.transform.basis = ray_cast_3d.global_transform.basis
		get_node("/root/world").add_child(bullet_instance)


func _on_area_3d_body_entered(body):
	print("body entering")
	if body.is_in_group("enemy"):
		locked_on_body = body
		locked_on = true


func _on_area_3d_body_exited(body):
	print("body exiting")
	if body.is_in_group("enemy"):
		locked_on = false
		locked_on_body = null


func _on_timer_timeout():
	if locked_on:
		turret_shot()
	
