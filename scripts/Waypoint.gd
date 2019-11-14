extends Area2D

export (int) var area_id = 0

signal body_entered_waypoint(body_id, waypoint_id)

func _on_Area2D_body_entered(body):
	emit_signal("body_entered_waypoint", body.id, area_id)


