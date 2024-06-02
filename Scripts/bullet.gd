extends Node3D

@export var speed = 40

@onready var mesh_instance_3d = $MeshInstance3D
@onready var ray_cast_3d = $RayCast3D
@onready var burger = $burger

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0,0, -speed) * delta
		

#using Timer signal to delete bullet after 10 seconds of flying through the air
func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_burger_body_entered(body):
	burger.visible = false
	ray_cast_3d.visible = false
	ray_cast_3d.enabled = false
	if body.is_in_group("enemy"):
		print("hit called")
		body.hit()
	
	#after emitting delete bullet
	await get_tree().create_timer(1.0).timeout
	queue_free()
	
	pass # Replace with function body.
