extends Node2D

onready var bomb = $Bomb


func _ready():
	bomb.add_wire("BombClock/Output", "OrGate/Input2")
	bomb.add_wire("BatteryPack/Output", "LightNode/Input")
	bomb.add_wire("OrGate/Output", "Explosive/Input")
