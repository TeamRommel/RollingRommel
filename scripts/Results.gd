extends Control

var show_totals = false
var results: Array = []
var sorted_champ_results: Array = []
var players: Array = []

onready var results_title = get_node("CenterContainer/VBoxContainer/Label")
onready var results_name_1 = get_node("CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer_Name/Name_1")
onready var results_name_2 = get_node("CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer_Name/Name_2")
onready var results_name_3 = get_node("CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer_Name/Name_3")
onready var results_name_4 = get_node("CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer_Name/Name_4")

onready var results_points_0 = get_node("CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer_Points/Points_0")
onready var results_points_1 = get_node("CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer_Points/Points_1")
onready var results_points_2 = get_node("CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer_Points/Points_2")
onready var results_points_3 = get_node("CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer_Points/Points_3")
onready var results_points_4 = get_node("CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer_Points/Points_4")

# Called when the node enters the scene tree for the first time.
func _ready():
	results = GameSettings.track_results
	sorted_champ_results = GameSettings.players
	sort_champ_points()
	results_name_1.set_text(results[0][0])
	results_name_2.set_text(results[1][0])
	results_name_3.set_text(results[2][0])
	results_name_4.set_text(results[3][0])
	results_points_0.set_text("Points")
	results_points_1.set_text(String(results[0][2]))
	results_points_2.set_text(String(results[1][2]))
	results_points_3.set_text(String(results[2][2]))
	results_points_4.set_text(String(results[3][2]))

func sort_champ_points():
	
	for i in range(1, sorted_champ_results.size()):
		var current_item = sorted_champ_results[i]
		var current_pos = i
	
		while current_pos > 0 and sorted_champ_results[current_pos - 1].championship_points < current_item.championship_points:
			sorted_champ_results[current_pos] = sorted_champ_results[current_pos - 1]
			current_pos = current_pos - 1
		sorted_champ_results[current_pos] = current_item

func draw_totals():
	if GameSettings.current_level < GameSettings.levels.size():
		results_title.set_text("Championship Table")
	else:
		results_title.set_text("Final Standings")
	results_name_1.set_text(sorted_champ_results[0].player_name)
	results_name_2.set_text(sorted_champ_results[1].player_name)
	results_name_3.set_text(sorted_champ_results[2].player_name)
	results_name_4.set_text(sorted_champ_results[3].player_name)
	results_points_1.set_text(String(sorted_champ_results[0].championship_points))
	results_points_2.set_text(String(sorted_champ_results[1].championship_points))
	results_points_3.set_text(String(sorted_champ_results[2].championship_points))
	results_points_4.set_text(String(sorted_champ_results[3].championship_points))

func _on_ContinueButton_pressed():
	if not show_totals and GameSettings.gamemode == 1:
		show_totals = true
		draw_totals()
	else:
		if GameSettings.gamemode == 0:
			GameSettings.reset_cup_settings()
			get_tree().change_scene("res://scenes/MainMenu.tscn")

		elif GameSettings.gamemode == 1:
			if GameSettings.current_level < GameSettings.levels.size():
				get_tree().change_scene("res://scenes/GameScene.tscn")	
			else:
				GameSettings.reset_cup_settings()
				get_tree().change_scene("res://scenes/MainMenu.tscn")

