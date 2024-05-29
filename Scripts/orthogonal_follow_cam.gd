extends Camera3D

@onready var player = $"../NavigationRegion3D/player"
var speed_factor = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position, player.position, speed_factor * delta)
	
