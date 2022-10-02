extends Node2D

onready var bomb = $Bomb


func _ready():
	bomb.add_wire("BombClock/Output", "Explosive/Input")
