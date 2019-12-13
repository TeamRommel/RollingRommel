extends VideoPlayer

var video_length = 34.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Check if video is at the end or spacebar button is pressed
# If either is true then change scene to Main menu
func _process(delta):
	if (get_stream_position() >= video_length) or (Input.is_action_pressed('action_1_1')):
		get_tree().change_scene("res://scenes/MainMenu.tscn")

