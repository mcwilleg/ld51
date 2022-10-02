extends Node2D

onready var input_1 = $Input1
onready var input_2 = $Input2
onready var output = $Output


func get_power_source(found):
	if found.has(self):
		return null
	found.append(self)
	var i1 = input_1.get_power_source(found)
	var i2 = input_2.get_power_source(found)
	if i1 != null and i2 != null:
		return i1
	return null
