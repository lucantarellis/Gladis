extends Marker2D
# TODO: corte justo cuando logré hacer que la mira aparezca y desaparezca, quedaría empezar a spawnear las balas correctamente
@export var distance: int = 35
@export var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if direction == Vector2.ZERO:
		self.hide()
	else:
		show()
	# TODO : Habría que probar el get_axis que devuelve un float
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	self.position = direction * distance
