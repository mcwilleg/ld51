extends Node2D

var powered = false
var power_source = null
var exploded = false

onready var connector = $Input
onready var audio = $Audio


func _physics_process(_delta):
	power_source = get_power_source([])
	if power_source != null and not exploded:
		exploded = true
		GameState.emit_signal("explode")
		if not GameState.silent:
			audio.play()


func get_power_source(found):
	if found.has(self):
		return null
	found.append(self)
	if connector != null and connector.has_method("get_power_source"):
		return connector.get_power_source(found)
	return null
