extends Marker2D

var _all_items:Array[Item] = []
var item
var instance

# TODO: Acomodar todas las Areas2D por variables unicas

func _ready():
	$Area2D.hide()
	#SignalBus.item_picked_up.connect(pickup_item)
	$Area2D.body_entered.connect(pickup_item)
	
	for file in DirAccess.get_files_at("res://data/items"):
		var resource_file = "res://data/items/" + file
		var item:Item = load(resource_file) as Item
		_all_items.append(item)

func _on_timer_timeout():
	var position_x = int(randf_range(50, 590))
	var position_y = int(randf_range(50, 150))
	
	self.position = Vector2(position_x, position_y)
	
	if len(self.get_children()) == 2:
		instance.queue_free()
	item = _all_items.pick_random()
	instance = item.scene.instantiate()
	$Area2D.show()
	add_child(instance)

func pickup_item(body):
	#print("signal received ", body)
	$Area2D.hide()
	if body.has_method("on_item_pickup"):
		body.on_item_pickup(item)
		if instance != null:
			instance.queue_free()
	
