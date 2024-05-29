extends Node3D

@onready var gun_barrel = $RayCast3D
@onready var gun_animation = $AnimationPlayer

var bullet = load("res://Scenes/bullet.tscn")
var bullet_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if Input.is_action_just_pressed("shoot"):
		
		if !gun_animation.is_playing():
			gun_animation.play("shoot")
			bullet_instance = bullet.instantiate()
			bullet_instance.position = gun_barrel.global_position
			bullet_instance.transform.basis = gun_barrel.global_transform.basis
			get_node("/root/world").add_child(bullet_instance)
