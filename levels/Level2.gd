extends Node2D

onready var bomb = $Bomb


func _ready():
	bomb.add_wire("BombClock/Output", "SplitGate/Input")
	bomb.add_wire("BatteryPack/Output", "LightNode/Input")
	bomb.add_wire("SplitGate/Output1", "OrGate/Input1")
	bomb.add_wire("SplitGate/Output2", "OrGate/Input2")
	bomb.add_wire("OrGate/Output", "Explosive/Input")
