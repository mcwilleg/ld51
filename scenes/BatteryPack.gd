extends Node2D

var power_source = get_instance_id()


func get_power_source(found):
	if found.has(self):
		return null
	found.append(self)
	return power_source
