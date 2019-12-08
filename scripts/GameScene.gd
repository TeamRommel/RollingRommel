extends Node2D

onready var car_stats = $CarStats
#onready var player = $PlayerVehicle
#onready var cpu = $CPUVehicle
onready var navigation = $Navigation2D
onready var tilemap = get_node("Navigation2D/Level_1/TileMap3")
onready var target_container = get_node("target_container")
onready var label_container = get_node("label_container")
onready var waypoints = get_node("waypoints").get_children()
onready var p1_laps = get_node("p1_laps")
#onready var cpu_label = $CPU_Label
#onready var player_label = $Player_Label

# Target sprite, used for drawing debug waypoints
var target = load("res://scenes/target.tscn")

var player_car = preload("res://scenes/PlayerVehicle.tscn")
var cpu_car = preload("res://scenes/CPUVehicle.tscn")
var players = []
var screen_players = []
var player_labels = []


# Level specifications:
var total_waypoints: int = 0
var total_laps: int = 5
var race_result = []


# Called when the node enters the scene tree for the first time.
func _ready():
	print(tilemap)
	#player.car_stats = car_stats
	#cpu.goal = waypoints[0].position
	#player.waypoints = waypoints
	#cpu.nav = navigation
	#cpu.trackpoints = waypoints
	total_waypoints = waypoints.size()
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
			plr.rotation_degrees = 180
			if (player.get_player_id() == 2):
				plr.position = Vector2(540, 420)
			elif (player.get_player_id() == 3):
				plr.position = Vector2(590, 420)
			else:
				plr.position = Vector2(540, 470)
			plr.id = player.get_player_id()
			plr.goal = waypoints[0].position
			plr.nav = navigation
			plr.waypoints = waypoints
			plr.must_turn_dist_forward = player.must_turn_dist_forward
			screen_players.append(plr)
			lbl.rect_position = plr.position + Vector2(-10, -30)
			player.set_no_of_waypoints(total_waypoints)
			player.set_no_of_laps(total_laps)
			player.connect("lap_complete", self, "count_laps")
			player.connect("race_complete", self, "check_race_finish")
			add_child(plr)
		else:
			var plr = player_car.instance()
			plr.tilemap = tilemap
			plr.rotation_degrees = 180
			plr.car_stats = car_stats
			plr.position = Vector2(590, 470)
			plr.id = player.get_player_id()
			plr.waypoints = waypoints
			screen_players.append(plr)
			lbl.rect_position = plr.position + Vector2(-10, -30)
			player.set_no_of_waypoints(total_waypoints)
			player.set_no_of_laps(total_laps)
			player.connect("lap_complete", self, "count_laps")
			player.connect("race_complete", self, "check_race_finish")
			add_child(plr)
		

func _process(delta):
	# Debug. Draw AI waypoints
	draw_tracks()
	# Draw labels on top of vehicles
	draw_labels()
	pass

func connect_to_waypoints():
	for i in waypoints.size():
		waypoints[i].connect("body_entered_waypoint", self, "check_laps")

func check_laps(body, area):
	players[body].set_current_waypoint(area)
	#print("Body ", body, " entered area ", area)

func count_laps(player_id: int, lap_no:int, lap_time: float):
	print ("Player %s completed a lap" % player_id)
	if player_id == 0:
		p1_laps.set_text("Player 1\nLap: %s\nTime: %2.2f" % [lap_no, lap_time])

func check_race_finish(player_id: int, best_lap: float):
	race_result.append(player_id)
	print("Player %s finished the race!" % (player_id + 1))
	if race_result.size() == players.size():
		print("Race finished!")
		for i in range(0, players.size()):
			print("Position %s: Player %s" % [i + 1, players[race_result[i]].player_name])

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
    