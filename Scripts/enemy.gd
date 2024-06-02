extends CharacterBody3D

var player = null
const SPEED = 3.0
var health = 2


@export var player_path := "/root/world/NavigationRegion3D/player"
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var gpu_particles_3d = $GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#velocity comes from CharacterBody3D
	velocity = Vector3.ZERO
	#navigation that only works with one model??
	navigation_agent_3d.set_target_position(player.global_transform.origin)
	var next_nav_point = navigation_agent_3d.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	if !gpu_particles_3d.emitting:
		move_and_slide()


func hit():
	health -= 1
	gpu_particles_3d.emitting = true
	if health <=0:
		queue_free()
