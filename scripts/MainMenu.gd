extends Control

func _ready():
	$TextureRect/players1Ring.visible = true
	$TextureRect/difficulty1Ring.visible = true
	GameSettings.no_of_humans = 1
	GameSettings.difficulty = 0


func _on_TextureButton_pressed():
<<<<<<< HEAD
	if($TextureRect/DesertRing.visible):
		get_tree().change_scene("res://scenes/GameScene.tscn")	
	elif($TextureRect/SingleRing.visible):
		get_tree().change_scene("res://scenes/SingleRaceMenu.tscn")
func _on_SingleGame_pressed():
	$TextureRect/SingleRing.visible = true
	$TextureRect/DesertRing.visible = false
=======
	GameSettings.create_players()
	get_tree().change_scene("res://scenes/GameScene.tscn")	

func _on_SingleGame_pressed():
	GameSettings.create_players()
	get_tree().change_scene("res://scenes/SingleRaceMenu.tscn")
>>>>>>> d9dba0721f7cd8c465a3fb33114c699fad6b5a03

func _on_DesertCup_pressed():
	$TextureRect/SingleRing.visible = false
	$TextureRect/DesertRing.visible = true
	GameSettings.gamemode = 1

func _on_playersButton1_pressed():
	$TextureRect/players1Ring.visible = true
	$TextureRect/players2Ring.visible = false
	GameSettings.no_of_humans = 1

func _on_playersButton2_pressed():
	$TextureRect/players1Ring.visible = false
	$TextureRect/players2Ring.visible = true
	GameSettings.no_of_humans = 2

func _on_difficulty1_pressed():
	$TextureRect/difficulty1Ring.visible = true
	$TextureRect/difficulty2Ring.visible = false
	$TextureRect/difficulty3Ring.visible = false
	GameSettings.difficulty = 0

func _on_difficulty2_pressed():
	$TextureRect/difficulty1Ring.visible = false
	$TextureRect/difficulty2Ring.visible = true
	$TextureRect/difficulty3Ring.visible = false
	GameSettings.difficulty = 1

func _on_difficulty3_pressed():
	$TextureRect/difficulty1Ring.visible = false
	$TextureRect/difficulty2Ring.visible = false
	$TextureRect/difficulty3Ring.visible = true
	GameSettings.difficulty = 2
