extends Node2D

onready var current_level = GameSettings.levels[GameSettings.current_level]
onready var car_stats = $CarStats
onready var navigation = $Navigation2D
onready var standings = $Standings
onready var race_finished_timer = $RaceFinishedTimer
var level_scene
var tilemap
var waypoints

onready var target_container = get_node("target_container")
onready var label_container = get_node("label_container")


# Target sprite, used for drawing debug waypoints
var target = load("res://scenes/target.tscn")

var player_car = preload("res://scenes/PlayerVehicle.tscn")
var cpu_car = preload("res://scenes/CPUVehicle.tscn")

var players = []
var screen_players = []
var player_labels = []


# Level specifications:
var total_waypoints: int = 0
var total_laps: int = 0
var race_result = []


# Called when the node enters the scene tree for the first time.
func _ready():
	level_scene = current_level.instance()
	
	navigation.add_child(level_scene)
	tilemap = level_scene.get_node("Zones")
	waypoints = level_scene.get_node("WaypointContainer").get_children()

	#player.car_stats = car_stats
	total_waypoints = waypoints.size()
	total_laps = level_scene.lap_count
	connect_to_waypoints()
	init_players()

# TODO: See if this could be moved to PlayerVehicle.gd or somewhere else.
func init_players():
	players = GameSettings.get_players()
	for player in players:
		var lbl = Label.new()
		lbl.text = player.get_player_name()
		lbl.set("custom_colors/font_color", Color(1,0,0))
		player_labels.append(lbl)
		label_container.add_child(lbl)
		
		if player.is_player_cpu():
			var plr = cpu_car.instance()
			plr.tilemap = tilemap
			plr.rotation_degrees = get_player_rotation()
			if (player.get_player_id() == 2):
				plr.position = level_scene.start_pos_2
			elif (player.get_player_id() == 3):
				plr.position = level_scene.start_pos_3
			else:
				plr.position = level_scene.start_pos_1
			plr.id = player.get_player_id()
			plr.goal = waypoints[0].position
			plr.nav = navigation
			plr.waypoints = waypoints
			plr.must_turn_dist_forward = player.must_turn_dist_forward
			screen_players.append(plr)
			lbl.rect_position = plr.position + Vector2(-10, -30)
			player.set_no_of_waypoints(total_waypoints)
			player.set_no_of_laps(total_laps)
			player.completed_laps = 0
			player.best_lap = 999.99
			player.connect("lap_complete", self, "count_laps")
			player.connect("race_complete", self, "check_race_finish")
			add_child(plr)
		else:
			var plr = player_car.instance()
			plr.tilemap = tilemap
			plr.rotation_degrees = get_player_rotation()
			plr.car_stats = car_stats
			plr.position = level_scene.start_pos_0
			plr.id = player.get_player_id()
			plr.waypoints = waypoints
			screen_players.append(plr)
			lbl.rect_position = plr.position + Vector2(-10, -30)
			player.set_no_of_waypoints(total_waypoints)
			player.set_no_of_laps(total_laps)
			player.completed_laps = 0
			player.best_lap = 999.99
			player.connect("lap_complete", self, "count_laps")
			player.connect("race_complete", self, "check_race_finish")
			add_child(plr)
		
func get_player_rotation():
	match level_scene.start_direction:
		"LEFT":
			return 180
		"RIGHT":
			return 0
		"UP":
			return -90
		"DOWN":
			return 90

func _process(delta):
	# Debug. Draw AI waypoints
	#draw_tracks()
	# Draw labels on top of vehicles
	draw_labels()
	pass

func connect_to_waypoints():
	for i in waypoints.size():
		waypoints[i].connect("body_entered_waypoint", self, "check_laps")

func check_laps(body, area):
	players[body].set_current_waypoint(area)

func count_laps(player_id: int, lap_no:int, lap_time: float):
	standings.update_lap(player_id, lap_no, lap_time)

func check_race_finish(player_id: int, best_lap: float):
	race_result.append([players[player_id].player_name, best_lap, GameSettings.race_points[race_result.size()]])
	if race_result.size() == players.size():
		GameSettings.track_results = race_result
		GameSettings.complete_level()
		race_finished_timer.start()
		for i in range(0, players.size()):
			players[i].disconnect("lap_complete", self, "count_laps")
			players[i].disconnect("race_complete", self, "check_race_finish")
			screen_players[i].finish_race()

func draw_labels():
	for i in player_labels.size():
		player_labels[i].rect_position = screen_players[i].position + Vector2(-10, -30)

func draw_tracks():
	# Clear previous tracks
	for child in target_container.get_children():
		target_container.remove_child(child)
		child.queue_free()

	# Draw new tracks
	for i in screen_players[1].path.size():
		var trgt = target.instance()
		trgt.position = screen_players[1].path[i]
		target_container.add_child(trgt)
    

func _on_RaceFinishedTimer_timeout():
	get_tree().change_scene("res://scenes/Results.tscn")	
