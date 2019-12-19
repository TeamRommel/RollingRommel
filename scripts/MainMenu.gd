extends Control

func _ready():
	setup_switches()	

func setup_switches():
	match GameSettings.no_of_humans:
		1:
			$TextureRect/players1Ring.visible = true
		2:
			$TextureRect/players2Ring.visible = true

	match GameSettings.difficulty:
		0:
			$TextureRect/difficulty1Ring.visible = true
		1:
			$TextureRect/difficulty2Ring.visible = true
		2:
			$TextureRect/difficulty3Ring.visible = true

	match GameSettings.gamemode:
		0:
			$TextureRect/SingleRing.visible = true
		1:
			$TextureRect/DesertRing.visible = true

func _on_TextureButton_pressed():
	GameSettings.create_players()
	if($TextureRect/DesertRing.visible):
		get_tree().change_scene("res://scenes/ControlsMenu.tscn")
	elif($TextureRect/SingleRing.visible):
		get_tree().change_scene("res://scenes/SingleRaceMenu.tscn")

func _on_SingleGame_pressed():
	$TextureRect/SingleRing.visible = true
	$TextureRect/DesertRing.visible = false
	GameSettings.gamemode = 0

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
