extends Node2D

export (PackedScene) var rombito
export (PackedScene) var triangulito

# Declare member variables here. Examples:
var agujeros = []
var rombitos = []
var triangulitos = []
var randomizer = RandomNumberGenerator.new()
var textura_negro = preload("res://negro.png")
var scale_negro = Vector2(0.2,0.2)
var maxQntyTriangulitos = 10
var score = 0
var maxScores = [0,0,0,0,0,0,0,0,0,0]

func _process(delta):
	for triangle in triangulitos:
		triangle.player_position = $Personaje.position

# Called when the node enters the scene tree for the first time.
func _ready():
	_initialize_game()
	
func _get_position_vector():
	var vectorResultado = _generate_random_vector()
	while(_has_anyone_closer(vectorResultado)):
		vectorResultado = _generate_random_vector()
	return 	vectorResultado

func _has_anyone_closer(vector):
	var result = false
	for agujero in agujeros:
		if(agujero.position.distance_to(vector)<200):
			result = true
	return result		
	
func _rombo_touched(body):
	score = score + 1
	$Score/ScoreQuantity.text = str(score)

func _instance_rombitos():
	var position_rombito
	for i in range(0, 5):
		var rombitoCreado 
		rombitoCreado = rombito.instance()
		position_rombito = _generate_random_vector()
		rombitoCreado.set_position(position_rombito)
		rombitoCreado.connect("body_entered",self,"_rombo_touched")
		rombitos.insert(i,rombitoCreado) 
		add_child(rombitos[i])	
		
func _instance_agujeros():
	var position_negro 
	for i in range(0, 5):
		var agujero
		agujero = Sprite.new()
		position_negro = _get_position_vector()
		agujero.set_position(position_negro)
		agujero.z_index=-1
		agujero.set_texture(textura_negro)
		agujero.set_scale(scale_negro)
		agujeros.insert(i,agujero) 
		add_child(agujeros[i])


func _on_Timer_timeout():
	_instance_rombitos()

func _on_TriangulosTimer_timeout():
	if(_full_triangles()):
		_delete_older_triangle()
	else:	
		_instance_new_triangle()

func _instance_new_triangle():
	var trianguloCreado = triangulito.instance()
	var position_triangulo = _generate_random_vector()
	var agujero = agujeros[round(randomizer.randf_range(0,4))]
	trianguloCreado.set_position(agujero.position)
	trianguloCreado.connect("body_entered",self,"_triangulo_touched")
	triangulitos.insert(0,trianguloCreado) 
	add_child(triangulitos[0])	

func _full_triangles():
	return triangulitos.size()==maxQntyTriangulitos
	
func _delete_older_triangle():
	var triangulo_a_borrar = triangulitos.pop_back()
	triangulo_a_borrar.hide()
	triangulo_a_borrar.queue_free()
	
func _generate_random_vector():
	return Vector2(randomizer.randf_range(100, 868),randomizer.randf_range(100, 464))

func _game_over():
	$TriangulosTimer.stop()
	$RombitosTimer.stop()
	for agujero in agujeros:
		agujero.hide()
		agujero.queue_free()
	agujeros = []
	for triangulo in triangulitos:
		triangulo.hide()
		triangulo.queue_free()
	triangulitos = []
	for rombito in rombitos:
		rombito.hide()
		rombito.queue_free()
	rombitos = []
	$Personaje.hide()
	$Score.hide()
	$background.hide()
	maxScores.append(score)
	maxScores.sort_custom(self,"sort_ascending")
	print(maxScores)
	score = 0
	$Score/ScoreQuantity.text = str(score)
	$GameOver/Button.show()
	$GameOver/gameover.show()
	$GameOver/Button2.show()
		
func _initialize_game():
	$HighScores/fondonegro.hide()
	$HighScores/PlayAgainButton.hide()
	$background.show()
	$Score.show()
	$Personaje.show()
	$Personaje.set_position(Vector2(0,0))
	$GameOver/Button.hide()
	$GameOver/gameover.hide()
	$GameOver/Button2.hide()
	$HighScores/HighScores.hide()
	$HighScores/FirstPosition.hide()
	$HighScores/SecondPosition.hide()
	$HighScores/ThirdPosition.hide()
	$HighScores/FourthPosition.hide()
	$HighScores/FifthPosition.hide()
	$HighScores/SixthPosition.hide()
	$HighScores/SeventhPosition.hide()
	$HighScores/EighthPosition.hide()
	$HighScores/NinthPosition.hide()
	$HighScores/TenthPosition.hide()
	_instance_agujeros()
	_instance_rombitos()
	$RombitosTimer.start()
	$TriangulosTimer.start()
		
func _triangulo_touched(body):
	if(body.name == "Personaje"):
		_game_over()

func sort_ascending(a, b):
	if a > b:
		return true
	return false

func _on_Button_pressed():
	_ready()


func _on_Button2_pressed():
	$GameOver/Button.hide()
	$GameOver/gameover.hide()
	$GameOver/Button2.hide()
	$HighScores/fondonegro.show()
	$HighScores/PlayAgainButton.show()
	$HighScores/HighScores.show()
	$HighScores/FirstPosition/Score.text = str(maxScores[0])
	$HighScores/FirstPosition.show()
	$HighScores/SecondPosition/Score.text = str(maxScores[1])
	$HighScores/SecondPosition.show()
	$HighScores/ThirdPosition/Score.text = str(maxScores[2])
	$HighScores/ThirdPosition.show()
	$HighScores/FourthPosition/Score.text = str(maxScores[3])
	$HighScores/FourthPosition.show()
	$HighScores/FifthPosition/Score.text = str(maxScores[4])
	$HighScores/FifthPosition.show()
	$HighScores/SixthPosition/Score.text = str(maxScores[5])
	$HighScores/SixthPosition.show()
	$HighScores/SeventhPosition/Score.text = str(maxScores[6])
	$HighScores/SeventhPosition.show()
	$HighScores/EighthPosition/Score.text = str(maxScores[7])
	$HighScores/EighthPosition.show()
	$HighScores/NinthPosition/Score.text = str(maxScores[8])
	$HighScores/NinthPosition.show()
	$HighScores/TenthPosition/Score.text = str(maxScores[9])
	$HighScores/TenthPosition.show()


func _on_PlayAgainButton_pressed():
	_ready()
