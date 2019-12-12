extends Node

var no_of_players: int = 0
var no_of_humans: int = 0
var current_level: int = 4
var players: Array = []
var player_class = preload("PlayerData.gd")
var levels: Array = []

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
	var p1 = player_class.new("Monty", 0, false)
	var cpu = player_class.new("Erwin", 1, true, 200)
	var cpu2 = player_class.new("Ludwig", 2, true, 225)
	var cpu3 = player_class.new("Patton", 3, true, 225)
	add_player(p1)
	add_player(cpu)
	add_player(cpu2)
	add_player(cpu3)

func complete_level():
	current_level += 1
	
func get_players():
	return players
	
func add_player(player):
	players.append(player)

# Player objects created with new() must be manually removed on quit.
func _exit_tree():
	for player in players:
		player.free()