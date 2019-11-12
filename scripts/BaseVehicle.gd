extends RigidBody2D

# Values that affect handling
export (int) var acceleration = 8000
export (int) var forward_power_max = 10000
export (int) var reverse_power_max = -5000
export (float) var rotation_speed = 1100
export (float) var slip_factor = 0.975
export (float) var friction_factor = 0.95

# Values calculated during runtime
var rotation_dir = 0
var engine_power

# Booleans
export (bool) var debug = false

# Scenes
var car_stats

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)


func _process(delta):
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

	if Input.is_action_pressed('right'):
		rotation_dir = 1
	if Input.is_action_pressed('left'):
		rotation_dir = -1
	
	if Input.is_action_pressed('down'):
		if (engine_power > reverse_power_max):
			engine_power -= acceleration * delta
	if Input.is_action_pressed('up'):
		if (engine_power <= forward_power_max):
			engine_power += acceleration * delta
		else:
			engine_power = forward_power_max
	
	if not Input.is_action_pressed('up') and not Input.is_action_pressed('down'):
		engine_power = 0
	
func _physics_process(delta):
	get_input(delta)
	# Calculate forward and sideways velocity. These are used to calculate linear velocity.
	var forwards_velocity = Vector2.RIGHT.rotated(rotation) * linear_velocity.dot(Vector2.RIGHT.rotated(rotation)) ;
	var sideways_velocity = Vector2.UP.rotated(rotation) * linear_velocity.dot(Vector2.UP.rotated(rotation))

	# Calculate forces
	var forwards_force = Vector2.RIGHT.rotated(rotation) * engine_power * friction * delta
	var friction_force = -forwards_velocity * friction_factor
	var total_force = forwards_force + friction_force

	# Apply forces and torque
	set_applied_force(total_force);
	set_linear_velocity(forwards_velocity + (sideways_velocity * slip_factor))
	set_applied_torque(rotation_dir * rotation_speed)