extends Control

func _on_TextureButton_pressed():
	get_tree().change_scene("res://scenes/GameScene.tscn")	

func _on_SingleGame_pressed():
	$TextureRect/SingleRing.visible = true
	$TextureRect/DesertRing.visible = false

func _on_DesertCup_pressed():
	$TextureRect/SingleRing.visible = false
	$TextureRect/DesertRing.visible = true
