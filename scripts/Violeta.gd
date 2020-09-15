extends KinematicBody2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const pointer_treshold = 50.0
const velocidad_escalar = 200.0

var velocidad = Vector2(0,0)
var dash = false;
var direccion;

# Called when the node enters the scene tree for the first time.
func _ready():
	position=velocidad
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var puntero = get_local_mouse_position()
	var velocidad = velocidad_escalar
	if puntero.length() > pointer_treshold:
		if !dash:
			direccion = puntero.normalized()
			$VioletaSprite.look_at(get_global_mouse_position())
		else:
			velocidad = velocidad *3
		var position_to = direccion * (velocidad) * delta 	
		position += position_to
				
func _input(ev):
	if ev is InputEventKey and ev.scancode == 32:
		if(!dash):
			dash = true
			print(dash)
			$Dash.start()


func _on_Dash_timeout():
	dash = false;
	pass # Replace with function body.
