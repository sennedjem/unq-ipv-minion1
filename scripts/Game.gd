extends Node2D

export (PackedScene) var rombito
export (PackedScene) var triangulito

# Declare member variables here. Examples:
var agujeros = []
var rombitos = []
var triangulitos = []
var randomizer = RandomNumberGenerator.new()
var texture_agujero = preload("res://textures/Agujero.png")
var maxQntyTriangulitos = 10
var score = 0
var maxScores = [0,0,0,0,0,0,0,0,0,0]

func _process(delta):
	for triangle in triangulitos:
		triangle.player_position = $Violeta.position

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
	var scale_negro = Vector2(0.2,0.2)
	var position_negro 
	for i in range(0, 5):
		var agujero
		agujero = Sprite.new()
		position_negro = _get_position_vector()
		agujero.set_position(position_negro)
		agujero.z_index=-1
		agujero.set_texture(texture_agujero)
		agujero.set_scale(scale_negro)
		agujeros.insert(i,agujero) 
		add_child(agujeros[i])
		
func _instance_new_triangle():
	var trianguloCreado = triangulito.instance()
	var position_triangulo = _generate_random_vector()
	var agujero = agujeros[round(randomizer.randf_range(0,4))]
	trianguloCreado.set_position(agujero.position)
	trianguloCreado.connect("body_entered",self,"_triangulo_touched")
	triangulitos.insert(0,trianguloCreado) 
	add_child(triangulitos[0])	

func _on_Timer_timeout():
	_instance_rombitos()

func _on_TriangulosTimer_timeout():
	if(_full_triangles()):
		_delete_older_triangle()
	else:	
		_instance_new_triangle()

func _full_triangles():
	return triangulitos.size()==maxQntyTriangulitos
	
func _delete_older_triangle():
	var triangulo_a_borrar = triangulitos.pop_back()
	triangulo_a_borrar.hide()
	triangulo_a_borrar.queue_free()
	
func _generate_random_vector():
	return Vector2(randomizer.randf_range(100, 868),randomizer.randf_range(100, 464))

func _clean_array(arrayName):
	for i in self[arrayName]:
		i.hide()
		i.queue_free()
	self[arrayName] = []	

func _clean_game_scene():
	$Violeta.hide()
	$Score.hide()
	$GameBackground.hide()
	_clean_array("agujeros")
	_clean_array("triangulitos")
	_clean_array("rombitos")
	
func sort_ascending(a, b):
	if a > b:
		return true
	return false	
	
func _update_score():
	maxScores.append(score)
	maxScores.sort_custom(self,"sort_ascending")
	score = 0
	$Score/ScoreQuantity.text = str(score)
	
func _show_game_over_screen():
	$GameOver/PlayAgainButton.show()
	$GameOver/GameOverBackground.show()
	$GameOver/HighScoresButton.show()

func _game_over():
	$TriangulosTimer.stop()
	$RombitosTimer.stop()
	_clean_game_scene()
	_update_score()
	_show_game_over_screen()
		
func _initialize_game():
	$HighScores/HighScoreBackground.hide()
	$HighScores/PlayAgainButton.hide()
	$GameBackground.show()
	$Score.show()
	$Violeta.show()
	$Violeta.set_position(Vector2(0,0))
	$GameOver/PlayAgainButton.hide()
	$GameOver/GameOverBackground.hide()
	$GameOver/HighScoresButton.hide()
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
	if(body.name == "Violeta"):
		_game_over()

func _on_Button_pressed():
	_ready()


func _on_Button2_pressed():
	$GameOver/PlayAgainButton.hide()
	$GameOver/GameOverBackground.hide()
	$GameOver/HighScoresButton.hide()
	$HighScores/HighScoreBackground.show()
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
