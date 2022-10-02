extends Node2D


onready var bomb = $Bomb


func _ready():
	bomb.add_wire("BombClock/Output", "OrGate/Input1")
	bomb.add_wire("BatteryPack/Output", "AndGate/Input2")
	bomb.add_wire("AndGate/Output", "Explosive/Input")
