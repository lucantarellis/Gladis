extends Node

func _ready():
	#SignalBus.attacking.connect(attacking)
	pass

func _process(delta):
	pass

func play_animation():
	%AnimationPlayer.play("swing")

# TODO: limpiar código y borrar el contactbox de las armas
#func _on_contactbox_body_entered(body):
	#podría agregar un grupo que sea "character" y ya
	#if body.has_method("on_item_pickup"):
		#SignalBus.item_picked_up.emit(body) 
		#queue_free()
