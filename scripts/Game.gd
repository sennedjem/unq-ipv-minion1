extends Node2D

export (PackedScene) var rombito
export (PackedScene) var triangulito

# Declare member variables here. Examples:
var agujeros = []
var rombitos = []
var triangulitos = []
var randomizer = RandomNumberGenerator.new()
var texture_agujero = preload("res://textures/Agujero.png")
var max_qnty_triangulitos = 10
var score = 0
var max_scores = [0,0,0,0,0,0,0,0,0,0]
var high_score_position_labels = [] 
var high_score_position_text_labels = []


func _process(delta):
	for triangle in triangulitos:
		triangle.player_position = $Violeta.position

# Called when the node enters the scene tree for the first time.
func _ready():
	high_score_position_labels = [
		$HighScores/FirstPosition,
		$HighScores/SecondPosition,
		$HighScores/ThirdPosition,
		$HighScores/FourthPosition,
		$HighScores/FifthPosition,
		$HighScores/SixthPosition,
		$HighScores/SeventhPosition,
		$HighScores/EighthPosition,
		$HighScores/NinthPosition,
		$HighScores/TenthPosition	
	]	
	high_score_position_text_labels = [
		$HighScores/FirstPosition/Score,
		$HighScores/SecondPosition/Score,
		$HighScores/ThirdPosition/Score,
		$HighScores/FourthPosition/Score,
		$HighScores/FifthPosition/Score,
		$HighScores/SixthPosition/Score,
		$HighScores/SeventhPosition/Score,
		$HighScores/EighthPosition/Score,
		$HighScores/NinthPosition/Score,
		$HighScores/TenthPosition/Score	
	]	
	_initialize_game()
	
func _get_position_vector():
	var vector_result = _generate_random_vector()
	while(_has_anyone_closer(vector_result)):
		vector_result = _generate_random_vector()
	return 	vector_result

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
	for i in range(0, 5):
		_instance_generic(rombito.instance(),_generate_random_vector(),"rombitos",i,"_rombo_touched")
		
func _instance_agujeros():
	for i in range(0, 5):
		_instance_generic(_instance_agujero(),_get_position_vector(),"agujeros",i,null)
		
func _instance_triangle():
	var agujero = _get_random_agujero()
	_instance_generic(triangulito.instance(),agujero.position,"triangulitos",0,"_triangulo_touched")

func _instance_agujero():
	var scale_negro = Vector2(0.2,0.2)
	var agujero = Sprite.new()
	agujero.z_index=-1
	agujero.set_texture(texture_agujero)
	agujero.set_scale(scale_negro)
	return agujero	

func _instance_generic(instance,position,array_name,array_position,collition_function):
	instance.set_position(position)
	if(collition_function):
		instance.connect("body_entered",self,collition_function)
	self[array_name].insert(array_position,instance) 
	add_child(instance)
		
func _get_random_agujero():
	return agujeros[round(randomizer.randf_range(0,4))]

func _on_Timer_timeout():
	_instance_rombitos()

func _on_TriangulosTimer_timeout():
	if(_full_triangles()):
		_delete_older_triangle()
		pass
	else:	
		pass
		_instance_triangle()

func _full_triangles():
	return triangulitos.size()==max_qnty_triangulitos
	
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
	max_scores.append(score)
	max_scores.sort_custom(self,"sort_ascending")
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
		
func _hide_high_score_screen():
	$HighScores/HighScoreBackground.hide()
	$HighScores/PlayAgainButton.hide()	
	$HighScores/HighScores.hide()
	for high_score_position in high_score_position_labels:
		high_score_position.hide()	
		
func _show_game_scene():
	$GameBackground.show()
	$Score.show()
	$Violeta.show()
	$Violeta.set_position(Vector2(0,0))		
		
func _hide_game_over_screen():
	$GameOver/PlayAgainButton.hide()
	$GameOver/GameOverBackground.hide()
	$GameOver/HighScoresButton.hide()		
		
func _initialize_game():
	_hide_high_score_screen()
	_show_game_scene()
	_hide_game_over_screen()
	_instance_agujeros()
	_instance_rombitos()
	$RombitosTimer.start()
	$TriangulosTimer.start()
		
func _triangulo_touched(body):
	if(body.name == "Violeta"):
		_game_over()
		
func _show_high_score_screen():
	$HighScores/HighScoreBackground.show()
	$HighScores/PlayAgainButton.show()
	$HighScores/HighScores.show()
	for i in range(0, 9):
		high_score_position_labels[i].show()
		high_score_position_text_labels[i].text = str(max_scores[i])

func _on_PlayAgainButton_pressed():
	_ready()

func _on_HighScoresButton_pressed():
	_hide_game_over_screen()
	_show_high_score_screen()
