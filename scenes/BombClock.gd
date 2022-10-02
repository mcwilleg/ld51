class_name BombClock extends Node2D

var powered = false

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
	if timer.is_stopped() and not powered:
		return
	var seconds_left = floor(timer.time_left)
	var millis_left = floor((timer.time_left - seconds_left) * 1000.0)
	time_label.text = "%02d.%03d" % [seconds_left, millis_left]


func start_timer():
	timer.start()
	beeping.play()


func _on_Timer_timeout():
	powered = true
	GameState.emit_signal("times_up")
	audio.play()


func _on_explode():
	beeping.stop()
	timer.stop()
