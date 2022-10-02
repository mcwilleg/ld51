extends Node2D

onready var bomb = $Bomb


func _ready():
	bomb.add_wire("BombClock/Output", "SplitGate/Input")
	bomb.add_wire("BatteryPack/Output", "AndGate/Input1")
	bomb.add_wire("SplitGate/Output1", "LightNode/Input")
	bomb.add_wire("SplitGate/Output2", "AndGate/Input2")
	bomb.add_wire("AndGate/Output", "Explosive/Input")
