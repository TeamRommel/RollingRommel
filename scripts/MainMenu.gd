extends Control

func _on_TextureButton_pressed():
	get_tree().change_scene("res://scenes/GameScene.tscn")	

func _on_SingleGame_pressed():
	get_tree().change_scene("res://scenes/SingleRaceMenu.tscn")

func _on_DesertCup_pressed():
	$TextureRect/SingleRing.visible = false
	$TextureRect/DesertRing.visible = true

func _on_playersButton1_pressed():
	$TextureRect/players1Ring.visible = true
	$TextureRect/players2Ring.visible = false

func _on_playersButton2_pressed():
	$TextureRect/players1Ring.visible = false
	$TextureRect/players2Ring.visible = true

func _on_difficulty1_pressed():
	$TextureRect/difficulty1Ring.visible = true
	$TextureRect/difficulty2Ring.visible = false
	$TextureRect/difficulty3Ring.visible = false

func _on_difficulty2_pressed():
	$TextureRect/difficulty1Ring.visible = false
	$TextureRect/difficulty2Ring.visible = true
	$TextureRect/difficulty3Ring.visible = false

func _on_difficulty3_pressed():
	$TextureRect/difficulty1Ring.visible = false
	$TextureRect/difficulty2Ring.visible = false
	$TextureRect/difficulty3Ring.visible = true
