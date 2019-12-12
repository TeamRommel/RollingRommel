extends VideoPlayer

var video_length = 34.4

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _process(delta):
	if get_stream_position() >= video_length:
		get_parent().queue_free()
		get_tree().change_scene("res://scenes/MainMenu.tscn")

