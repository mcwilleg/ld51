extends Node2D

signal drag(object, from, to)
signal drag_to(object, to)
signal times_up()
signal explode()

export var current_level = -1
export var total_levels = 3
export var game_over = true
export var exploded = false
export var silent = false

var hovered_object = null
var held_object = null


func _physics_process(_delta):
	if exploded:
		return
	var mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("mouse_left"):
		if hovered_object != null:
			held_object = hovered_object
	if Input.is_action_just_released("mouse_left"):
		if hovered_object != null:
			#print(str(held_object) + " > " + str(hovered_object))
			emit_signal("drag_to", held_object, hovered_object)
		held_object = null
	if Input.is_action_pressed("mouse_left"):
		if held_object != null:
			var from_pos = held_object.global_position
			emit_signal("drag", held_object, from_pos, mouse_pos)


func reset():
	current_level = -1
	game_over = false
	exploded = false
