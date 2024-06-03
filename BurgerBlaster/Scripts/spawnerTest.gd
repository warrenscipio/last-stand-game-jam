@tool
extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DebugDraw3D.draw_square($Node3D.global_position, 0.5, Color.GREEN)
	if ($spawner != null):
		DebugDraw3D.draw_cylinder_ab(global_position, $spawner.global_position, $spawner.spawnerCircleRadius, Color.GREEN)
	
