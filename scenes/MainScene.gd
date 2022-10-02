extends Node2D

onready var camera = $Camera
onready var level_container = $LevelContainer
onready var timer = $Timer
onready var anim = $AnimationPlayer


func _ready():
	$VictoryBG.visible = false
	$DeathBG.visible = false
	_load_levels()
	GameState.connect("times_up", self, "_on_times_up")
	GameState.connect("explode", self, "_on_explode")


func _load_levels():
	for level in level_container.get_children():
		level.queue_free()
	for i in range(GameState.total_levels):
		var level_scene = load("res://levels/Level" + str(i) + ".tscn")
		var level = level_scene.instance()
		level_container.add_child(level)
		level.global_position.x = i * 640


func go_to_next_level():
	if GameState.exploded:
		return
	GameState.current_level += 1
	if GameState.current_level == GameState.total_levels:
		_on_victory()
	else:
		camera.global_position.x = GameState.current_level * 640
		start_level(GameState.current_level)


func start_level(level_idx):
	var level = level_container.get_child(level_idx)
	var bomb = level.get_node("Bomb")
	bomb.start_timer()


func _on_times_up():
	timer.start()


func _on_explode():
	GameState.exploded = true
	timer.stop()
	$DeathBG.visible = true
	anim.play("death")


func _on_victory():
	$VictoryBG.visible = true
	anim.play("victory")


func _on_Timer_timeout():
	go_to_next_level()
