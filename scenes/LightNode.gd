extends Node2D

var power_source = null

onready var sprite = $Sprite
onready var input = $Input


func _physics_process(_delta):
	power_source = get_power_source([])
	if power_source != null:
		sprite.frame = 1
	else:
		sprite.frame = 0


func get_power_source(found):
	if found.has(self):
		return null
	found.append(self)
	if input != null and input.has_method("get_power_source"):
		return input.get_power_source(found)
	return null
