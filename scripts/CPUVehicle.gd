extends "res://scripts/BaseVehicle.gd"

var nav = null setget set_nav
var goal = Vector2() setget set_goal
var forward_dir = Vector2()
var target_dir = Vector2()
export var seek_distance = 75

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
	draw_line(Vector2(0,0), forward_dir * 50, Color(255,0,0), 3)
	draw_line(Vector2(0,0), target_dir * 50, Color(0,255,0), 3)
	

func get_input(delta):

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
		var angle_between = forward_dir.angle_to(target_dir) * (180/PI)

		# Choose where to turn
		if angle_between < -5:
			rotation_dir = -1
		elif angle_between >= 5:
			rotation_dir = 1

		# Put the pedal to the metal
		if (engine_power <= forward_power_max):
			engine_power += acceleration * delta
		else:
			engine_power = forward_power_max
		
		# ...but if the angle is too big, slow down.
		if abs(angle_between) > 60:
			engine_power = 0