extends Sprite



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const pointer_treshold = 50.0
const velocidad_escalar = 10.0
var velocidad = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var puntero = get_local_mouse_position()
	if puntero.length() > pointer_treshold:
		var direccion = puntero.normalized()
		#print(puntero.length())
		#print(direccion)
		position += direccion * (velocidad_escalar*20) * delta 
