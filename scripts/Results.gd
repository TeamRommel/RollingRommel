extends Control

var results: Array = []
onready var results_label = get_node("CenterContainer/VBoxContainer/ResultLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	results = GameSettings.track_results
	results_label.set_text("1. %s %20.2f\n2. %s %20.2f\n3. %s %20.2f\n4. %s %20.2f" % [results[0][0], results[0][1],results[1][0], results[1][1], results[2][0], results[2][1], results[3][0], results[1][1]])
	

func _on_ContinueButton_pressed():
	if GameSettings.gamemode == 0:
		get_tree().change_scene("res://scenes/Results.tscn")
	elif GameSettings.gamemode == 1:
		if GameSettings.current_level < GameSettings.levels.size():
			get_tree().change_scene("res://scenes/GameScene.tscn")	
		else:
			get_tree().change_scene("res://scenes/MainMenu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
