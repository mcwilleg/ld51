class_name BombClock extends Node2D

var power_source = null

onready var time_label = $Time
onready var timer = $Timer
onready var audio = $Audio
onready var beeping = $SecondsBeep


func _ready():
	var seconds_left = floor(timer.wait_time)
	var millis_left = floor((timer.wait_time - seconds_left) * 1000.0)
	time_label.text = "%02d.%03d" % [seconds_left, millis_left]
	timer.connect("timeout", self, "_on_Timer_timeout")
	GameState.connect("explode", self, "_on_explode")


func _physics_process(_delta):
	# this condition is met before each bomb starts
	if timer.is_stopped() and power_source == null:
		return
	var seconds_left = floor(timer.time_left)
	var millis_left = floor((timer.time_left - seconds_left) * 1000.0)
	time_label.text = "%02d.%03d" % [seconds_left, millis_left]


func get_power_source(found):
	if found.has(self):
		return null
	found.append(self)
	return power_source


func start_timer():
	timer.start()
	if not GameState.silent:
		beeping.play()


func _on_Timer_timeout():
	power_source = get_instance_id()
	GameState.emit_signal("times_up")
	if not GameState.silent:
		audio.play()


func _on_explode():
	beeping.stop()
	timer.stop()
