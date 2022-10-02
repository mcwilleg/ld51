extends Node2D

onready var bomb = $Bomb


func _ready():
	bomb.add_wire("BombClock/Output", "SplitGate/Input")
	bomb.add_wire("SplitGate/Output1", "OrGate/Input1")
	bomb.add_wire("SplitGate/Output2", "NotGate/Input")
	bomb.add_wire("NotGate/Output", "OrGate2/Input1")
	bomb.add_wire("OrGate2/Output", "NotGate2/Input")
	bomb.add_wire("NotGate2/Output", "OrGate/Input2")
	bomb.add_wire("OrGate/Output", "Explosive/Input")
