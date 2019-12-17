extends Node2D

export (int) var lap_count = 0
export (String) var start_direction = "LEFT"
export (Vector2) var start_pos_0 = Vector2.ZERO
export (Vector2) var start_pos_1 = Vector2.ZERO
export (Vector2) var start_pos_2 = Vector2.ZERO
export (Vector2) var start_pos_3 = Vector2.ZERO
var start_positions: Array = []

func _ready():
    start_positions.append(start_pos_0)
    start_positions.append(start_pos_1)
    start_positions.append(start_pos_2)
    start_positions.append(start_pos_3)
