extends CharacterBody3D

var target = null
const SPEED = 3.0
var health = 2
var spawnPosition

@export var target_path := "/root/world/NavigationRegion3D/burgerStand"
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var gpu_particles_3d = $GPUParticles3D
@onready var mouth = $mouth
@onready var red_body = $redBody
@onready var blue_body = $blueBody
@onready var eyes = $eyes

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(target_path)
	blue_body.visible = false
	red_body.visible = true
	mouth.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#velocity comes from CharacterBody3D
	velocity = Vector3.ZERO
	#navigation that only works with one model??
	if health > 0:
		navigation_agent_3d.set_target_position(target.global_transform.origin)
	else:
		navigation_agent_3d.set_target_position(spawnPosition)
	
	var next_nav_point = navigation_agent_3d.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP)
	if !gpu_particles_3d.emitting or blue_body.visible:
		move_and_slide()

func hit():
	health -= 1
	gpu_particles_3d.emitting = true
	if health <=0:
		if red_body.visible:
			target.player_money = target.player_money + 1
		blue_body.visible = true
		red_body.visible = false
		mouth.visible = false
		eyes.position.z = -0.45
		await get_tree().create_timer(5.0).timeout
		queue_free()
