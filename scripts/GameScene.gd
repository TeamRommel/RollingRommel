extends Node2D

onready var car_stats = $CarStats
onready var player = $PlayerVehicle
onready var cpu = $CPUVehicle
onready var navigation = $Navigation2D
onready var target_container = get_node("target_container")
onready var waypoints = get_node("waypoints").get_children()
onready var cpu_label = $CPU_Label
onready var player_label = $Player_Label

var target = load("res://scenes/target.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.car_stats = car_stats
	cpu.goal = waypoints[0].position
	player.waypoints = waypoints
	cpu.nav = navigation
	cpu.trackpoints = waypoints
	connect_to_waypoints()

func _process(delta):
	# Debug. Draw AI waypoints
	#draw_tracks()
	draw_labels()
	pass

func connect_to_waypoints():
	for i in waypoints.size():
		waypoints[i].connect("body_entered_waypoint", self, "check_laps")


func check_laps(body, area):
	print("Body ", body, " entered area ", area)

func draw_labels():
	cpu_label.rect_position = cpu.position + Vector2(-10, -30)
	player_label.rect_position = player.position + Vector2(-10, -30)

func draw_tracks():
	# Clear previous tracks
	for child in target_container.get_children():
		target_container.remove_child(child)
		child.queue_free()

	# Draw new tracks
	for i in cpu.path.size():
		var trgt = target.instance()
		trgt.position = cpu.path[i]
		target_container.add_child(trgt)
