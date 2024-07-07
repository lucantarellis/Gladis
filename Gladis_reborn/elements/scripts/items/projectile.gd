extends CharacterBody2D

@export var damage:int
@export var speed:int

func start(_position, _direction) -> void:
	rotation = _direction.angle()
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()
		#velocity = velocity.bounce(collision.get_normal())
		#if collision.get_collider().has_method("hit"):
			#collision.get_collider().hit()

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()
