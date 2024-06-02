extends Node2D
@onready var label = $Label
@onready var burger_bar = $burgerBar
var count = 0
@export var burger_capacity = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	burger_bar.value = 0
	label.text = str(0)
	pass # Replace with function body.
	
func _input(event):
	if Input.is_action_just_pressed("make_burger"):
		burger_bar.value = burger_bar.value + 5
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = str(count)
	if burger_bar.value == burger_bar.max_value:
		if count < burger_capacity:
			count = count +1
			burger_bar.value = 0
		
	pass
