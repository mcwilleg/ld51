extends Node2D

var power_source = null
var exploded = false

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
	for child in get_children():
		if child.has_method("get_power_source"):
			var child_source = child.get_power_source(found)
			if child_source != null:
				return child_source
	return null
