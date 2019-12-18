extends Control


func _on_Track1_pressed():
    GameSettings.current_level=0
    GameSettings.gamemode=0
    get_tree().change_scene("res://scenes/GameScene.tscn")


func _on_Track2_pressed():
    GameSettings.current_level=1
    GameSettings.gamemode=0
    get_tree().change_scene("res://scenes/GameScene.tscn")


func _on_Track3_pressed():
    GameSettings.current_level=2
    GameSettings.gamemode=0
    get_tree().change_scene("res://scenes/GameScene.tscn")

func _on_Track4_pressed():
    GameSettings.current_level=3
    GameSettings.gamemode=0
    get_tree().change_scene("res://scenes/GameScene.tscn")

func _on_Track5_pressed():
    GameSettings.current_level=4
    GameSettings.gamemode=0
    get_tree().change_scene("res://scenes/GameScene.tscn")