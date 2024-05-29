extends Node3D
@export var camera_distance = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at_from_position((Vector3.UP + Vector3.BACK) * camera_distance,        
					   get_parent().translation, Vector3.UP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
