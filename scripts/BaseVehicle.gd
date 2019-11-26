extends RigidBody2D

# Player ID
export (int) var id = 0

# Values that affect handling and speed
export (int) var acceleration = 10000
export (int) var forward_power_max = 10000
export (int) var reverse_power_max = -5000
export (float) var rotation_speed = 750
export (float) var slip_factor = 0.975
export (float) var friction_factor = 0.975
export (int) var nitro_power = 200

# Values calculated during runtime
var rotation_dir: float = 0
var engine_power: float = 0

# Vehicle shadow
onready var shadow = $TankShadow
var shadow_offset_pxl: float = 1.5

# Nitro timer
onready var nitro_timer = $NitroTimer

# Booleans
#export (bool) var debug = false
export (bool) var is_cpu = false
var can_use_nitro:bool = true
var will_use_nitro:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

func get_input(delta) -> void:
	pass
	
func offset_shadow() -> void:
	shadow.position = Vector2(shadow_offset_pxl, shadow_offset_pxl).rotated(-rotation)

func _physics_process(delta):
	offset_shadow()
	get_input(delta)
	# Calculate forward and sideways velocity. These are used to calculate linear velocity.
	var forwards_velocity = Vector2.RIGHT.rotated(rotation) * linear_velocity.dot(Vector2.RIGHT.rotated(rotation)) ;
	var sideways_velocity = Vector2.UP.rotated(rotation) * linear_velocity.dot(Vector2.UP.rotated(rotation))

	# Calculate forces
	var forwards_force = Vector2.RIGHT.rotated(rotation) * engine_power * friction_factor * delta
	var friction_force = -forwards_velocity * friction_factor
	var total_force = forwards_force + friction_force

	# Apply forces and torque
	set_applied_force(total_force);
	set_linear_velocity(forwards_velocity + (sideways_velocity * slip_factor))
	set_applied_torque(rotation_dir * rotation_speed)
	if will_use_nitro:
		use_nitro()
		
func use_nitro() -> void:
	can_use_nitro = false
	will_use_nitro = false
	nitro_timer.start()
	apply_impulse(Vector2.ZERO, Vector2.RIGHT.rotated(rotation) * nitro_power)

func _on_NitroTimer_timeout() -> void:
	can_use_nitro = true
