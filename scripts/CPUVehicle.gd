extends "res://scripts/BaseVehicle.gd"

var nav = null setget set_nav
var goal = Vector2() setget set_goal
var forward_dir = Vector2()
var target_dir = Vector2()
var can_go_right: bool = true
var should_go_right: bool = false
var can_go_left: bool = true
var should_go_left: bool = false
var must_go_left: bool = false
var must_go_right: bool = false
var must_turn: bool = false
export var safe_dist_to_wall = 150
var angle_between = 0

export var seek_distance = 75

export (float) var min_dist_to_wall = 100
onready var ray_front: RayCast2D = get_node("CollisionShape2D/RayCast2D_Front")
onready var ray_r_front: RayCast2D = get_node("CollisionShape2D/RayCast2D_RF")
onready var ray_r_front_long: RayCast2D = get_node("CollisionShape2D/RayCast2D_RF_Long")
onready var ray_r_side: RayCast2D = get_node("CollisionShape2D/RayCast2D_R_Side")
onready var ray_l_front: RayCast2D = get_node("CollisionShape2D/RayCast2D_LF")
onready var ray_l_front_long: RayCast2D = get_node("CollisionShape2D/RayCast2D_LF_Long")
onready var ray_l_side: RayCast2D = get_node("CollisionShape2D/RayCast2D_L_Side")

var path
var trackpoints setget set_trackpoints
var current_trackpoint = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	is_cpu = true
	
func set_trackpoints(new_trackpoints):
	trackpoints = new_trackpoints

# Set target to player
func set_goal(new_goal):
	goal = new_goal
	if (nav):
		update_path()

# Update navigation
func set_nav(new_nav):
	nav = new_nav
	update_path()

# Update path if player position changes
func update_path():
	path = nav.get_simple_path(position, goal, true)
	if (path.size() == 0):
		pass

func _process(delta):
	update()

func _draw():
	# Draw debug lines for now.
	#draw_line(Vector2(0,0), forward_dir * 50, Color(255,0,0), 3)
	#draw_line(Vector2(0,0), target_dir * 50, Color(0,255,0), 3)
	pass
	

func get_input(delta):
	check_available_movement()
	# Start each frame with zero steering
	rotation_dir = 0

	# If there's still path positions to go until next waypoint...
	if (path.size() > 0):

		# Check distance to the current destination point
		var d = position.distance_to(path[0])

		# If we are close enough to the destination point, remove destination and pick next in queue.
		if d < seek_distance:
			path.remove(0)

			# If the path size is 0, we've reached the current destination. Time to move on.
			if (path.size() == 0):
				if (trackpoints != null):
					if current_trackpoint +1 < trackpoints.size():
						current_trackpoint +=1
						set_goal(trackpoints[current_trackpoint].position)
					else:
						# If we've gone through all waypoints, start next lap.
						current_trackpoint = 0
						set_goal(trackpoints[current_trackpoint].position)

			
		# Check where our nose is pointing. Forward direction (Vector2.RIGHT) is in relation to the object's orientation
		forward_dir = Vector2.RIGHT
		# Get target direction.
		target_dir = position.direction_to(path[0]).rotated(-rotation)
		
		# Check the angle between target dir and forward direction
		angle_between = forward_dir.angle_to(target_dir) * (180/PI)

		# Choose where to turn
		if angle_between < -5 and can_go_left:
			rotation_dir = -1
		elif angle_between > 5 and can_go_right:
			rotation_dir = 1

		if must_go_right or should_go_right:
			rotation_dir = 1
		if must_go_left or should_go_left:
			rotation_dir = -1


		# Put the pedal to the metal
		if (engine_power <= forward_power_max):
			engine_power += acceleration * delta
		else:
			engine_power = forward_power_max
		
		if abs(angle_between) > 75 and abs(angle_between) < 160:
			engine_power = engine_power * 0
			if angle_between < -5 and can_go_left:
				rotation_dir = -1
			elif angle_between > 5 and can_go_right:
				rotation_dir = 1



func check_available_movement():
	# Assume we can move
	can_go_right = true
	can_go_left = true
	should_go_left = false
	should_go_right = false
	must_go_left = false
	must_go_right = false
	#can_go_forward = true
	#can_go_backward = true
	var right_cumulative = 0
	var left_cumulative = 0

	
	if ray_l_front.is_colliding():
		left_cumulative += position.distance_to(ray_l_front.get_collision_point())
	else:
		left_cumulative += 168
	if ray_l_front_long.is_colliding():
		left_cumulative += position.distance_to(ray_l_front_long.get_collision_point())
	else:
		left_cumulative += 205
	if ray_l_side.is_colliding():
		left_cumulative += position.distance_to(ray_l_side.get_collision_point())
	else:
		left_cumulative += 100
		
	if left_cumulative < min_dist_to_wall:
		should_go_right = true
	if left_cumulative > safe_dist_to_wall:
		can_go_left = true


	if ray_r_front.is_colliding():
		right_cumulative += position.distance_to(ray_r_front.get_collision_point())
	else:
		right_cumulative += 168
	if ray_r_front_long.is_colliding():
		right_cumulative += position.distance_to(ray_r_front_long.get_collision_point())
	else:
		right_cumulative += 205
	if ray_r_side.is_colliding():
		right_cumulative += position.distance_to(ray_r_side.get_collision_point())
	else:
		right_cumulative += 100

	if right_cumulative < min_dist_to_wall:
		should_go_left = true
	if right_cumulative > safe_dist_to_wall:
		can_go_right = true


	#print("RightC: ", right_cumulative, " LeftC: ", left_cumulative)

	if ray_front.is_colliding():
		var front_dist = position.distance_to(ray_front.get_collision_point())
		if front_dist < 200:
			if right_cumulative > left_cumulative:
				must_go_right = true
			elif left_cumulative > right_cumulative:
				must_go_left = true

	

