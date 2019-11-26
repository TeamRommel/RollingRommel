extends "res://scripts/BaseVehicle.gd"

# Navigation decisions
var can_go_right: bool = true
var should_go_right: bool = false
var must_go_right: bool = false
var can_go_left: bool = true
var should_go_left: bool = false
var must_go_left: bool = false
var must_brake: bool = false

# Navigation decision related limits
export (float) var must_brake_dist_forward = 100
export (float) var must_turn_dist_forward = 250
export (int) var safe_dist_to_wall = 150
export (int) var seek_distance = 85
export (int) var ray_side_long = 205
export (int) var ray_side_mid = 170
export (int) var ray_side_short = 100

# Navigation related objects and values
var nav: Navigation2D = null setget set_nav
var goal: Vector2 = Vector2() setget set_goal
var forward_dir: Vector2 = Vector2()
var target_dir: Vector2 = Vector2()
var angle_between: float = 0
var path
var waypoints setget set_waypoints
var current_waypoint: int = 0

# Navigation raycasts
onready var ray_front: RayCast2D = get_node("CollisionShape2D/RayCast2D_Front")
onready var ray_r_front: RayCast2D = get_node("CollisionShape2D/RayCast2D_RF")
onready var ray_r_front_long: RayCast2D = get_node("CollisionShape2D/RayCast2D_RF_Long")
onready var ray_r_side: RayCast2D = get_node("CollisionShape2D/RayCast2D_R_Side")
onready var ray_l_front: RayCast2D = get_node("CollisionShape2D/RayCast2D_LF")
onready var ray_l_front_long: RayCast2D = get_node("CollisionShape2D/RayCast2D_LF_Long")
onready var ray_l_side: RayCast2D = get_node("CollisionShape2D/RayCast2D_L_Side")

# Called when the node enters the scene tree for the first time.
func _ready():
	is_cpu = true

func init_vehicle() -> void:
	pass
	

# Store current track's trackpoints
func set_waypoints(new_waypoints):
	waypoints = new_waypoints

# Set target to current trackpoint
func set_goal(new_goal):
	goal = new_goal
	if (nav):
		update_path()

# Update navigation
func set_nav(new_nav):
	nav = new_nav
	update_path()

# Update path if target trackpoint changes
func update_path():
	path = nav.get_simple_path(position, goal, true)
	if (path.size() == 0):
		pass

# Call update in order to enable _draw function
func _process(delta):
	update()

func _draw():
	# Draw debug lines for now.
	#draw_line(Vector2(0,0), forward_dir * 50, Color(255,0,0), 3)
	#draw_line(Vector2(0,0), target_dir * 50, Color(0,255,0), 3)
	pass
	

func get_input(delta):
	# Check raycasts to define possible movement directions
	check_available_movement()

	# Start each frame with zero steering
	rotation_dir = 0

	# If there's still path positions to go until next trackpoint...
	if (path.size() > 0):

		# Check distance to the current destination point
		var d = position.distance_to(path[0])

		# If we are close enough to the destination point, remove destination and pick next in queue.
		if d < seek_distance:
			path.remove(0)

			# If the path size is 0, we've reached the current destination. Time to move on.
			if (path.size() == 0):
				if (waypoints != null):
					if current_waypoint +1 < waypoints.size():
						current_waypoint +=1
						set_goal(waypoints[current_waypoint].position)
					else:
						# If we've gone through all waypoints, start next lap.
						current_waypoint = 0
						set_goal(waypoints[current_waypoint].position)

			
		# Check where our nose is pointing. Forward direction (Vector2.RIGHT) is in relation to the object's orientation
		forward_dir = Vector2.RIGHT
		# Get target direction.
		target_dir = position.direction_to(path[0]).rotated(-rotation)
		
		# Check the angle between target dir and forward direction
		angle_between = forward_dir.angle_to(target_dir) * (180/PI)

		# Choose where to turn in normal situation
		if angle_between < -5 and can_go_left:
			rotation_dir = -1
		elif angle_between > 5 and can_go_right:
			rotation_dir = 1

		# Choose where to turn when heading into a wall
		if must_go_right:
			rotation_dir = 1
		if must_go_left:
			rotation_dir = -1

		# Put the pedal to the metal
		if (engine_power <= forward_power_max):
			engine_power += acceleration * delta
		else:
			engine_power = forward_power_max

		# What to do if target is lost after, for instance, hitting a wall
		if abs(angle_between) > 75 and abs(angle_between) < 160:
			# If facing a wall and not moving forward, stop.
			if get_linear_velocity().length() < 1:
				engine_power = engine_power * 0
			
			# Choose the better direction to turn to.
			if angle_between < -5 and (can_go_left or should_go_left):
				rotation_dir = -1
			elif angle_between > 5 and (can_go_right or should_go_right):
				rotation_dir = 1

func check_available_movement():
	# Assume we can turn
	can_go_right = true
	can_go_left = true

	should_go_left = false
	should_go_right = false

	must_go_left = false
	must_go_right = false
	must_brake = false
	
	# Use cumulative values to decide which way is safe to turn
	var right_cumulative = ray_side_long + ray_side_mid + ray_side_short
	var left_cumulative = ray_side_long + ray_side_mid + ray_side_short

	# Check distances on left
	if ray_l_front.is_colliding():
		left_cumulative -= ray_side_mid - position.distance_to(ray_l_front.get_collision_point())
	if ray_l_front_long.is_colliding():
		left_cumulative -= ray_side_long - position.distance_to(ray_l_front_long.get_collision_point())
	if ray_l_side.is_colliding():
		left_cumulative -= ray_side_short - position.distance_to(ray_l_side.get_collision_point())

	if left_cumulative > safe_dist_to_wall:
		can_go_left = true

	# Check distances on right
	if ray_r_front.is_colliding():
		right_cumulative -= ray_side_mid - position.distance_to(ray_r_front.get_collision_point())
	if ray_r_front_long.is_colliding():
		right_cumulative -= ray_side_long - position.distance_to(ray_r_front_long.get_collision_point())
	if ray_r_side.is_colliding():
		right_cumulative -= ray_side_short - position.distance_to(ray_r_side.get_collision_point())

	if right_cumulative > safe_dist_to_wall:
		can_go_right = true
	
	# Which side is better
	if right_cumulative > left_cumulative:
		should_go_right = true
	else:
		should_go_left = true

	# Are we about to hit the wall?
	if ray_front.is_colliding():
		
		var front_dist = position.distance_to(ray_front.get_collision_point())
		if front_dist < must_turn_dist_forward:
			if right_cumulative > left_cumulative:
				must_go_right = true
			elif left_cumulative > right_cumulative:
				must_go_left = true
		elif front_dist < must_brake_dist_forward:
			must_brake = true

# Trigger path update once every second
func _on_path_timer_timeout():
	update_path()
