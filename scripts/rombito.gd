extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",self,"collion_now")
	pass # Replace with function body.

#func collion_now(body):
	#print('eeea2')
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_rombito_body_entered(body):
	self.hide()
	$CollisionShape2D.set_deferred("disabled",true)
	pass # Replace with function body.
