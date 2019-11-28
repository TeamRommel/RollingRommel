extends Node

var player_name: String = "ACE" setget set_player_name, get_player_name
var score: int = 0
var player_id: int = 0 setget set_player_id, get_player_id
var championship_points: int = 0
var selected_vehicle: int = 0 setget set_player_vehicle, get_player_vehicle
var is_cpu: bool = false
var must_turn_dist_forward = 250

# Level-based data
var total_waypoints: int = 0
var current_waypoint: int = 0
var completed_laps: int = 0
var total_laps: int = 0
var lap_time: float = 0
var best_lap: float = 0
var lap_start_time: int = 0

# Car stats
var acceleration: int = 10000
var forward_power: int = 10000
var reverse_power: int = forward_power / -2
var rotation_speed: int = 750
var slip_factor: float = 0.975
var friction_factor: float = 0.975

# Signals
signal lap_complete
signal race_complete

func _init(new_name="ACE", new_id=0, set_cpu=false, forw_turn_dist=250):
	player_name = new_name
	player_id = new_id
	is_cpu = set_cpu
	must_turn_dist_forward = forw_turn_dist

func set_player_as_cpu() -> void:
	is_cpu = true

func is_player_cpu() -> bool:
	return is_cpu

func set_player_name(new_name: String) -> void:
	player_name = new_name

func get_player_name() -> String:
	return player_name

func set_player_id(new_id: int) -> void:
	player_id = new_id
	
func get_player_id() -> int:
	return player_id
	
func set_player_vehicle(new_vehicle) -> void:
	selected_vehicle = new_vehicle

func get_player_vehicle() -> int:
	return selected_vehicle


# Lap related functions
func set_no_of_waypoints(total_waypoints_in_lvl: int) -> void:
	total_waypoints = total_waypoints_in_lvl

func set_no_of_laps(total_laps_in_lvl: int) -> void:
	total_laps = total_laps_in_lvl

func set_current_waypoint(waypoint_no) -> void:
	if current_waypoint + 1 == waypoint_no:
		current_waypoint += 1
	elif waypoint_no == 0 && current_waypoint + 1 == total_waypoints:
		current_waypoint = 1
		add_lap()
	else:
		lap_start_time = OS.get_ticks_msec()

func add_lap() -> void:
	completed_laps += 1
	lap_time = float(OS.get_ticks_msec() - lap_start_time) / 1000
	check_best_lap(lap_time)
	emit_signal("lap_complete", player_id, completed_laps, lap_time)
	if completed_laps == total_laps:
		emit_signal("race_complete", player_id, best_lap)

func check_best_lap(last_lap_time) -> void:
	if last_lap_time < best_lap:
		best_lap = lap_start_time
