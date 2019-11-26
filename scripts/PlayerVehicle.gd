extends "res://scripts/BaseVehicle.gd"

var car_stats
var waypoints
var waypoint_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if id == 1:
		check_sliders()
	
func check_sliders():
	# Read values set on CarStats scene and adjust values accordingly
	acceleration = car_stats.get_node("Acceleration_HSlider").value
	car_stats.get_node("AccelerationValue_Label").text = String(acceleration)

	forward_power_max = car_stats.get_node("EnginePower_HSlider").value
	car_stats.get_node("EnginePowerValue_Label").text = String(forward_power_max)

	rotation_speed = car_stats.get_node("TurnSpeed_HSlider").value
	car_stats.get_node("TurnSpeedValue_Label").text = String(rotation_speed)
	
	friction_factor = car_stats.get_node("Friction_HSlider").value
	car_stats.get_node("FrictionValue_Label").text = String(friction_factor)

	slip_factor = car_stats.get_node("Traction_HSlider").value
	car_stats.get_node("TractionValue_Label").text = String(slip_factor)

func get_input(delta):
	# Always start with zero steering
	rotation_dir = 0

	# Handle left and right keys. Prep for multiplayer.
	if Input.is_action_pressed('right_%s' % id):
		rotation_dir = 1
	if Input.is_action_pressed('left_%s' % id):
		rotation_dir = -1
	
	# Handle up and down keys. Prep for multiplayer.
	if Input.is_action_pressed('down_%s' % id):
		if (engine_power > reverse_power_max):
			engine_power -= acceleration * delta
	if Input.is_action_pressed('up_%s'% id):
		if (engine_power <= forward_power_max):
			engine_power += acceleration * delta
		else:
			engine_power = forward_power_max
	
	# If neither up nor down is pressed, kill engine.
	if not Input.is_action_pressed('up_%s' % id) and not Input.is_action_pressed('down_%s' % id):
		engine_power = 0
	
	# Apply nitro
	if Input.is_action_pressed('action_%s_1' % id):
		if can_use_nitro:
			will_use_nitro = true
			
func _on_Area2D_2_body_entered(body):
	waypoint_counter += 1

