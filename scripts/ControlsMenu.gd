extends Node2D

func _on_ContinueTimer_timeout():
	print("timeout")
	get_tree().change_scene("res://scenes/GameScene.tscn")
