extends Node2D

var player_1_time: float = 00.00
var player_2_time: float = 00.00
var player_3_time: float = 00.00
var player_4_time: float = 00.00

var player_1_lap: int = 0
var player_2_lap: int = 0
var player_3_lap: int = 0
var player_4_lap: int = 0

onready var p1_label = $P1_Label
onready var p2_label = $P2_Label
onready var p3_label = $P3_Label
onready var p4_label = $P4_Label

func update_lap(player_no, lap, time):
	match player_no:
		0:
			player_1_lap = lap
			player_1_time = time
			p1_label.set_text("    %s                  %2.2f" % [player_1_lap, player_1_time])
		1:
			player_2_lap = lap
			player_2_time = time
			p2_label.set_text("    %s                  %2.2f" % [player_2_lap, player_2_time])
		2:
			player_3_lap = lap
			player_3_time = time
			p3_label.set_text("    %s                  %2.2f" % [player_3_lap, player_3_time])
		3:
			player_4_lap = lap
			player_4_time = time
			p4_label.set_text("    %s                  %2.2f" % [player_4_lap, player_4_time])

