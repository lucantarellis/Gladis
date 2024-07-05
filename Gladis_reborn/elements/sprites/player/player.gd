extends CharacterBody2D

@export var _speed:int
@export var weapon:Gun
@export var direction:Vector2

@onready var dir
@onready var cooldown:bool
@onready var magazine:int
@onready var is_reloading:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	magazine = weapon.mag
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	dir = %Marker2D.global_position - global_position

	if Input.is_action_pressed("attack"):
		if is_reloading == false:
			if magazine == 0:
				reload()
			else:
				attack()
	
	if direction == Vector2.LEFT:
		# TODO: arreglar flip por scale -1
		%AnimatedSprite2D.flip_h = true
	elif direction == Vector2.RIGHT:
		%AnimatedSprite2D.flip_h = false
		
	velocity = direction * _speed
	
	move_and_slide()

#func on_item_pickup(item:Item):
	#if item.tag == "weapon":
		#print("I got a weapon!")
		#weapon = item
		#print("The weapon is ", weapon.name)

func attack():
	if cooldown == true:
		pass
	else:
		set_cooldown()
		# Creación de la bala
		var bullet = weapon.projectile.instantiate()
		# Posición
		bullet.start(%Marker2D.global_position, dir)
		# Spawn bala
		get_tree().root.add_child(bullet)
		# Restar una bala de la recámara
		magazine -= 1
		# Rango
		await get_tree().create_timer(weapon.range).timeout
		if bullet != null:
			bullet.queue_free()

func set_cooldown():
	cooldown = true
	await get_tree().create_timer(weapon.rate_of_fire).timeout
	cooldown = false
	
func reload():
	is_reloading = !is_reloading
	print("reloading")
	for i in range(weapon.mag):
		await get_tree().create_timer(weapon.reload).timeout
	is_reloading = !is_reloading
	print("finished reloading")
	magazine = 6
	
	
	
	
	
	
	# la escena de los items tiene que tener funciones como "get_animation" y "get_sprite" para manejar las acciones del humano
	#print("attacking!")
	#var attack = weapon.scene.instantiate()
	# ver comentario linea 24
	#attack.global_position = self.global_position + Vector2(10,0)
	#add_child(attack)
	#print(attack.has_method("play_animation"))
	#if attack.has_method("play_animation"):
	#	attack.move_local_x(20)
	#	attack.move_local_y(-10)
	#	attack.play_animation()
	#	await get_tree().create_timer(0.3).timeout
	#	attack.queue_free()
	
