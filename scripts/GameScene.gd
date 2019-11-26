extends Node2D

onready var car_stats = $CarStats
#onready var player = $PlayerVehicle
#onready var cpu = $CPUVehicle
onready var navigation = $Navigation2D
onready var target_container = get_node("target_container")
onready var waypoints = get_node("waypoints").get_children()
onready var cpu_label = $CPU_Label
onready var player_label = $Player_Label

# Target sprite, used for drawing debug waypoints
var target = load("res://scenes/target.tscn")
var player_car = preload("res://scenes/PlayerVehicle.tscn")
var cpu_car = preload("res://scenes/CPUVehicle.tscn")
var screen_players = []
var player_labels = []

# Level specifications:
var total_waypoints: int = 0
var total_laps: int = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	#player.car_stats = car_stats
	#cpu.goal = waypoints[0].position
	#player.waypoints = waypoints
	#cpu.nav = navigation
	#cpu.trackpoints = waypoints
	connect_to_waypoints()
	init_players()
	
func init_players():
	var players = GameSettings.get_players()
	for player in players:
		var lbl = Label.new()
		lbl.text = player.get_player_name()
		lbl.set("custom_colors/font_color", Color(1,0,0))
		player_labels.append(lbl)
		add_child(lbl)
		
		if player.is_player_cpu():
			var plr = cpu_car.instance()
			plr.rotation_degrees = 180
			if (player.get_player_id() == 2):
				plr.position = Vector2(470, 330)
			elif (player.get_player_id() == 3):
				plr.position = Vector2(520, 330)
			else:
				plr.position = Vector2(470, 360)
			plr.id = player.get_player_id()
			plr.goal = waypoints[0].position
			plr.nav = navigation
			plr.waypoints = waypoints
			plr.must_turn_dist_forward = player.must_turn_dist_forward
			screen_players.append(plr)
			lbl.rect_position = plr.position + Vector2(-10, -30)
			add_child(plr)
		else:
			var plr = player_car.instance()
			plr.rotation_degrees = 180
			plr.car_stats = car_stats
			plr.position = Vector2(520, 360)
			plr.id = player.get_player_id()
			plr.waypoints = waypoints
			screen_players.append(plr)
			lbl.rect_position = plr.position + Vector2(-10, -30)
			add_child(plr)

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
	print("Body ", body, " entered area ", area)

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
