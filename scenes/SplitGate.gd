extends Node2D

onready var input = $Input


func get_power_source(found):
	if found.has(self):
		return null
	found.append(self)
	return input.get_power_source(found)
