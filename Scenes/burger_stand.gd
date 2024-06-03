extends Node3D

@onready
var standHealthBar = $CanvasLayer/standHealth
var player_money = 0
@onready var money_display = $CanvasLayer/Label2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	money_display.text = str(player_money)
	
	pass
	
func takeDamage():
	standHealthBar.value -= 10

func _on_burger_building_zone_body_entered(body: Node3D):
	print(body.name + "entered. ")
	print('script filename: %s' % [ body.get_script().resource_path.get_file() ])
	
	if (body.name == "player"):
		body.isInBurgerStandZone = true
	else:
		# destroy enemy
		takeDamage()
		body.queue_free()

func _on_burger_building_zone_body_exited(body: Node3D):
	print(body.name + "exited. ")
	if (body.name == "player"):
		body.isInBurgerStandZone = false
