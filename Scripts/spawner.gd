extends Node3D
const enemyScenePath = "res://Scenes/enemy.tscn"
var enemyScene : PackedScene = preload(enemyScenePath)

@export
var spawnerCircleRadius = 10
@export
var timeBetweenSpawns = 1
@export
var totalSpawningTime = 10

@onready
var timeBetweenSpawnsTimer = $TimeBetweenSpawns
@onready
var totalSpawningTimeTimer = $TotalSpawningTime

# Called when the node enters the scene tree for the first time.
func _ready():
	timeBetweenSpawnsTimer.wait_time = timeBetweenSpawns
	totalSpawningTimeTimer.wait_time = totalSpawningTime

func getSpawnerCircleRadius():
	return spawnerCircleRadius

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnUnit():
	# get a random direction in the "unit circle"
	var rng := RandomNumberGenerator.new()
	var randX := rng.randf_range(-1.0, 1.0)
	var randZ := rng.randf_range(-1.0, 1.0)
	var randomVectorDir = Vector2(randX, randZ).normalized()
	#scale vector by radius, so that enemies are placed at the bounds  of the circle
	var scaledVectorDir = Vector3(randomVectorDir.x * spawnerCircleRadius, 3, randomVectorDir.y * spawnerCircleRadius)
	
	var enemy : Node3D = enemyScene.instantiate()
	get_tree().get_current_scene().add_child(enemy)
	enemy.set_global_position(scaledVectorDir)
	enemy.spawnPosition = scaledVectorDir
	print("spawner:",enemy.spawnPosition)
	
func _on_timer_timeout():
	spawnUnit()

func _on_total_spawning_time_timeout():
	queue_free()
