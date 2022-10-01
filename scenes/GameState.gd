extends Node2D

signal drag(object, from, to)
signal drag_to(object, to)
signal explode()

var hovered_object = null
var held_object = null


func _ready():
	connect("explode", self, "_on_explode")


func _physics_process(_delta):
	var mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("mouse_left"):
		if hovered_object != null:
			held_object = hovered_object
	if Input.is_action_just_released("mouse_left"):
		if hovered_object != null:
			print(str(held_object) + " > " + str(hovered_object))
			emit_signal("drag_to", held_object, hovered_object)
		held_object = null
	if Input.is_action_pressed("mouse_left"):
		if held_object != null:
			var from_pos = held_object.global_position
			emit_signal("drag", held_object, from_pos, mouse_pos)


func _on_explode():
	print("bomb exploded!")
