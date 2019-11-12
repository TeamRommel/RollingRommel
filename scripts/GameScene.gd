extends Node2D

onready var car_stats = $CarStats
onready var car = $BaseVehicle

# Called when the node enters the scene tree for the first time.
func _ready():
	car.car_stats = car_stats

