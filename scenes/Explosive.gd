extends Node2D


var powered = false


func power():
	if powered:
		return
	GameState.emit_signal("explode")
