extends Node3D

@onready var gun_barrel = $RayCast3D
@onready var gun_animation = $AnimationPlayer

var bullet = load("res://Scenes/bullet.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if Input.is_action_just_pressed("shoot"):
			if !gun_animation.is_playing():
				gun_animation.play("shoot")
				instance = bullet.instantiate()
				instance.position = gun_barrel.global_position
				instance.transform.basis = gun_barrel.global_transform.basis
				get_node("/root/box_map").add_child(instance)
