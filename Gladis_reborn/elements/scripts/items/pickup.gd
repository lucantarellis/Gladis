extends Node2D

var _all_items:Array[Item] = []
var item
var instance

func _ready():
	for file in DirAccess.get_files_at("res://data/items"):
		var resource_file = "res://data/items/" + file
		var item:Item = load(resource_file) as Item
		_all_items.append(item)

func _on_timer_timeout():
	if len(self.get_children()) == 2:
		instance.queue_free()
	item = _all_items.pick_random()
	instance = item.scene.instantiate()
	%Area2D.monitoring = true
	add_child(instance)

func _on_area_2d_body_entered(body):
	if body.has_method("on_item_pickup"):
		instance.queue_free()
		%Area2D.set_deferred("monitoring", false)
		body.on_item_pickup(item)
