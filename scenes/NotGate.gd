extends Node2D

onready var input = $Input
onready var output = $Output


func get_power_source(found):
	if found.has(self):
		return null
	found.append(self)
	var i = input.get_power_source(found)
	if i == null:
		return get_instance_id()
	else:
		return null
