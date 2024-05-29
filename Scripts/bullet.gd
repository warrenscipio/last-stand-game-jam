extends Node3D

const SPEED = 40

@onready var mesh_instance_3d = $MeshInstance3D
@onready var ray_cast_3d = $RayCast3D
@onready var gpu_particles_3d = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0,0, -SPEED) * delta
	if ray_cast_3d.is_colliding():
		mesh_instance_3d.visible = false
		gpu_particles_3d.emitting = true
		ray_cast_3d.enabled = false
		print(ray_cast_3d.get_collider())
		print(ray_cast_3d.get_collider().is_in_group("enemy"))
		if ray_cast_3d.get_collider().is_in_group("enemy"):
			print("hit called")
			ray_cast_3d.get_collider().hit()
		
		#after emitting delete bullet
		await get_tree().create_timer(1.0).timeout
		queue_free()
		

#using Timer signal to delete bullet after 10 seconds of flying through the air
func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.