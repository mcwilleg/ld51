extends Node2D

var powered = false
var exploded = false

onready var connector = $Input
onready var audio = $Audio


func _physics_process(_delta):
	if connector != null and connector.powered and not exploded:
		exploded = true
		GameState.emit_signal("explode")
		audio.play()
