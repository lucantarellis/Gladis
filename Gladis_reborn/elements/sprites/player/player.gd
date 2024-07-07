extends CharacterBody2D

### Player stats ###

# Attributes
@export var _speed:int
@export var _max_health:float
@export var _health:float
@export var _stamina:float

# Inventory
@export var weapon:Gun
@export var magic:Magic

####################

#### Player HUD ####

@onready var reload_bar = %ReloadBar
@onready var marker_2d = %Marker2D

####################

@onready var dir
@onready var cooldown:bool
@onready var magazine:int
@onready var is_reloading:bool = false

func _ready():
	magazine = weapon.mag

func _physics_process(delta):
	if reload_bar.value == reload_bar.max_value:
		reload_bar.hide()

	var direction = Input.get_vector("left", "right", "up", "down")
	dir = marker_2d.global_position - global_position

	if Input.is_action_pressed("attack"):
		if is_reloading == false:
			if magazine == 0:
				reload()
			else:
				attack()
				
	if Input.is_action_just_pressed("magic"):
		cast_spell()
	
	if direction == Vector2.LEFT:
		# TODO: arreglar flip por scale -1
		%AnimatedSprite2D.flip_h = true
	elif direction == Vector2.RIGHT:
		%AnimatedSprite2D.flip_h = false
		
	velocity = direction * _speed
	
	move_and_slide()

func on_item_pickup(pickup):
	match pickup.type:
		0:
			match pickup.buff:
				"rof":
					weapon.rate_of_fire -= pickup.rate_of_fire
				"range":
					weapon.range += pickup.range
				"reload":
					weapon.reload -= pickup.reload
				"mag":
					weapon.mag += pickup.mag
		1:
			weapon.projectile = pickup.scene
		2:
			magic = pickup

func attack():
	if cooldown == true:
		pass
	else:
		set_cooldown()
		# Creación de la bala
		var bullet = weapon.projectile.instantiate()
		# Posición
		bullet.start(marker_2d.global_position, dir)
		# Spawn bala
		# TODO: Para arreglar el knockback, tengo que hacer que la bala no spawnee encima del player
		get_tree().root.add_child(bullet)
		# Restar una bala de la recámara
		magazine -= 1
		reload_bar.value = magazine
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
	reload_bar.show()
	for i in range(weapon.mag):
		await get_tree().create_timer(weapon.reload).timeout
		reload_bar.value += 1
	is_reloading = !is_reloading
	magazine = 6
	
func cast_spell():
	if magic != null:
		print("I can cast ", magic.name)
	else:
		print("I don't have any spell.")
	#tengo que hacer una funcion general para eso? 
	#spell.start()
	
	
	
	
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
	
