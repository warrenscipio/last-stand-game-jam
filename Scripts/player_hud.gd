extends Node2D
@onready var label = $Label
@onready var burger_bar = $burgerBar
@onready var burger_count = 0
@export var burger_capacity = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	burger_bar.value = 0
	label.text = str(0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = str(burger_count)
	if burger_bar.value == burger_bar.max_value:
		burger_bar.value = 0
		if burger_count < burger_capacity:
			burger_count = burger_count +1
			burger_bar.value = 0
