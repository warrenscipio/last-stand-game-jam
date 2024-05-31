extends Node3D

# decouple act of throwing, managing item state from player
# instead of spawning, add pickup in range
@onready
var itemToThrow : RigidBody3D = $physicsBox
var player
var isItemHeld : bool = false

@export
var maxPickupDistance = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	# connect to signals
	# player must be a direct descendant of root node
	player = get_tree().get_current_scene().get_node("player")
	player.connect("try_pickup", on_try_pickup, 2)
	player.connect("throw_held_item", on_throw_held_item, 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if isItemHeld:
		updateItemHeldPos(itemToThrow, player.collisionShape)

func throw(throwFrom: Transform3D):
	var itemToThrow : RigidBody3D = get_child(0)
	itemToThrow.set_freeze_enabled(false)
	itemToThrow.apply_central_impulse(throwFrom.basis * Vector3(0,10,-20)) # what kind of multiplication are we doing here?

func updateItemHeldPos(item : RigidBody3D, nodeToHoldOver): 
	var abovePlayer : Vector3 = nodeToHoldOver.get_global_position() + Vector3(0, 5, 0)	
	set_global_position(abovePlayer)

func on_try_pickup(player: Variant):
	print("on_try_pickup")
	print(global_position.distance_to(player.global_position))
	if global_position.distance_to(player.global_position) <= maxPickupDistance:
		isItemHeld = true
		itemToThrow.set_freeze_enabled(true)

func on_throw_held_item(transformToThrowFrom): 
	print("throw_held_item")
	if isItemHeld:
		isItemHeld = false
		throw(transformToThrowFrom)
		
		
