extends Area2D


# Declare member variables here. Examples:
var player_position 
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocidad = 100
	var direccion = player_position - position
	position += direccion.normalized() * (velocidad ) * delta 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
