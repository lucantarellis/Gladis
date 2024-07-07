extends Marker2D

#var _all_items:Array[Item] = []
var _all_pickups:Pickups = load("res://data/items/_all_pickups.tres") as Pickups
var pickup
var instance
var choices:Array[int] = [0, 1, 2] # 0 si es "enhancement", 1 si es "projectile", 2 si es "magic"

# TODO: Acomodar todas las Areas2D por variables unicas

func _ready():
	$Area2D.hide()
	#SignalBus.item_picked_up.connect(pickup_item)
	$Area2D.body_entered.connect(pickup_item)
	
	
	#for file in DirAccess.get_files_at("res://data/items/pickups/"):
	#	var resource_file = "res://data/items/pickups/" + file
	#	var item:Item = load(resource_file) as Item
	#	_all_items.append(item)

func _on_timer_timeout():
	var position_x = int(randf_range(50, 590))
	var position_y = int(randf_range(50, 150))
	
	self.position = Vector2(position_x, position_y)
	
	if len(self.get_children()) == 2:
		instance.queue_free()
	
	var choice = choices.pick_random()
	print(choice)
	
	match choice:
		0:
			pickup = _all_pickups.enhancements.pick_random()
			create_pickup()
		1:
			pickup = _all_pickups.projectiles.pick_random()
			create_pickup()
		2:
			pickup = _all_pickups.magics.pick_random()
			create_pickup()

func pickup_item(body):
	$Area2D.hide()
	if body.has_method("on_item_pickup"):
		body.on_item_pickup(pickup)
		if instance != null:
			instance.queue_free()
			
func create_pickup():
	instance = pickup.scene.instantiate()
	$Area2D.show()
	add_child(instance)
	
