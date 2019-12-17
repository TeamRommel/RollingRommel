extends Node

var no_of_players: int = 0
var no_of_humans: int = 1
var current_level: int = 0
var players: Array = []
var player_class = preload("PlayerData.gd")
var levels: Array = []
var gamemode: int = 1
var track_results: Array = []
var race_points: Array = [25, 15, 12, 10]
var racers: Array = ["Monty", "George", "Erwin", "Ludwig"]

var track_1 = preload("res://scenes/tracks/track_1.tscn")
var track_2 = preload("res://scenes/tracks/track_2.tscn")
var track_3 = preload("res://scenes/tracks/track_3.tscn")
var track_4 = preload("res://scenes/tracks/track_4.tscn")
var track_5 = preload("res://scenes/tracks/track_5.tscn")
var player_car = preload("res://scenes/PlayerVehicle.tscn")
var cpu_car = preload("res://scenes/CPUVehicle.tscn")

func _ready():
	create_level_array()

func create_level_array() -> void:
	levels.append(track_1)
	levels.append(track_2)
	levels.append(track_3)
	levels.append(track_4)
	levels.append(track_5)

func _init():
	for i in range(0, no_of_humans):
		var player = player_class.new(racers[i], i, false)
		add_player(player)
	for i in range(no_of_humans, 4):
		var cpu = player_class.new(racers[i], i, true)
		add_player(cpu)

func complete_level():
	current_level += 1
	
func get_players():
	return players
	
func add_player(player):
	players.append(player)

func reset_cup_settings() -> void:
	current_level = 0

# Player objects created with new() must be manually removed on quit.
func _exit_tree():
	for player in players:
		player.free()