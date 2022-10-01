extends Node2D

export var connector_path: NodePath

var powered = false
var connector = null

onready var time_label = $Time
onready var timer = $Timer


func _ready():
	yield(get_tree(), "idle_frame")
	if connector_path != null and has_node(connector_path):
		connector = get_node(connector_path)


func _physics_process(_delta):
	var seconds_left = floor(timer.time_left)
	var millis_left = floor((timer.time_left - seconds_left) * 1000.0)
	time_label.text = "%02d.%03d" % [seconds_left, millis_left]


func _on_Timer_timeout():
	if powered:
		return
	powered = true
	if connector != null:
		connector.power()
