extends Node3D
@onready var animation_player = $AnimationPlayer
@onready var pivot_point = $StaticBody3D/pivot_point
@onready var ray_cast_3d = $StaticBody3D/pivot_point/barrel/RayCast3D
@onready var timer = $Timer

var bullet = load("res://Scenes/bullet.tscn")
var bullet_instance
var locked_on = false
var locked_on_body
@export 
var fire_rate = 0
var body_targets = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if we still have targets lock on to the closest
	if !body_targets.is_empty():
		locked_on_body = getClosestEnemy()
		locked_on = true
	
	if locked_on:
		#check if the other turret killed this enemy mid process
		if is_instance_valid(locked_on_body):
			pivot_point.look_at(locked_on_body.global_position)
			pivot_point.rotation.x = 0
			pivot_point.rotation.z = 0
			
#return the closest enemy to the turrent
func getClosestEnemy():
	var closestEnemy
	var minDistance = 1000
	for key in body_targets:
		var value = body_targets[key]
		var distance = self.global_position.distance_to(value.global_position)
		#only aim at targets that need to be shot
		if value.health > 0:
			if closestEnemy == null or (distance < minDistance):
				minDistance = distance
				closestEnemy = value
		
	return closestEnemy

func turret_shot():
	if !animation_player.is_playing():
		animation_player.play("shoot")
		bullet_instance = bullet.instantiate()
		bullet_instance.position = ray_cast_3d.global_position
		bullet_instance.transform.basis = ray_cast_3d.global_transform.basis
		get_node("/root/world").add_child(bullet_instance)

func _on_area_3d_body_entered(body):
	if body.is_in_group("enemy"):
		body_targets[body] = body
		locked_on_body = body
		locked_on = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("enemy"):
		body_targets.erase(body)
		locked_on = false
		locked_on_body = null


func _on_timer_timeout():
	if locked_on:
		turret_shot()
	
