extends Node2D

onready var camera = $Camera
onready var level_container = $LevelContainer
onready var timer = $Timer
onready var anim = $AnimationPlayer
onready var audio = $Audio


func _ready():
	GameState.connect("times_up", self, "_on_times_up")
	GameState.connect("explode", self, "_on_explode")
	$Camera/MainBG.visible = true
	anim.play("main_idle")
	$Camera/DeathBG.visible = false
	$Camera/VictoryBG.visible = false


func _physics_process(_delta):
	if not GameState.game_over:
		return
	if Input.is_action_just_pressed("ui_select"):
		GameState.reset()
		_load_levels()
		camera.global_position.x = -640
		$Camera/MainBG.visible = false
		$Camera/DeathBG.visible = false
		$Camera/VictoryBG.visible = false
		go_to_next_level()


func _load_levels():
	for level in level_container.get_children():
		level.queue_free()
	for i in range(GameState.total_levels):
		var level_scene = load("res://levels/Level" + str(i) + ".tscn")
		var level = level_scene.instance()
		level_container.add_child(level)
		level.global_position.x = i * 640


func go_to_next_level():
	if GameState.exploded or GameState.game_over:
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
	$Camera/DeathBG.visible = true
	anim.play("death")
	camera.smoothing_enabled = false
	camera.global_position.x = -640
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	camera.smoothing_enabled = true
	GameState.game_over = true


func _on_victory():
	$Camera/VictoryBG.visible = true
	anim.play("victory")
	audio.play()
	camera.global_position.x = -640
	GameState.game_over = true


func _on_Timer_timeout():
	go_to_next_level()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		anim.play("death_idle")
	if anim_name == "victory":
		anim.play("victory_idle")
